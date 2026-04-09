//
//  ListInteractorTests.swift
//  ToDosTests
//
//  Created by Дарья Саитова on 09.04.2026.
//

import XCTest

@testable import ToDos

@MainActor
final class ListInteractorTests: XCTestCase {
    var interactor: ListInteractor!
    
    var presenterMock: ListPresentationLogicMock!
    var userDefaultsMock: ContainsValueByKeyMock!
    var fetchServiceMock: FetchesListMock!
    var localStorageMock: StoresLocalDataMock!
    
    override func setUp() {
        super.setUp()
        presenterMock = ListPresentationLogicMock()
        userDefaultsMock = ContainsValueByKeyMock()
        fetchServiceMock = FetchesListMock()
        localStorageMock = StoresLocalDataMock()
        interactor = ListInteractor(
            presenter: presenterMock,
            userDefaults: userDefaultsMock,
            fetchService: fetchServiceMock,
            localStorage: localStorageMock
        )
    }
    
    override func tearDown() {
        presenterMock = nil
        userDefaultsMock = nil
        fetchServiceMock = nil
        localStorageMock = nil
        interactor = nil
        super.tearDown()
    }
    
    // MARK: - loadList
    
    func testLoadListFirstLaunchFetchesFromNetwork() {
        // Given
        userDefaultsMock.boolStub = false
        let items = [ListItem(id: 1, todo: "Test", completed: false)]
        let list = List(todos: items)
        fetchServiceMock.listStub = list
        
        // When
        interactor.loadList()
        
        // Then
        XCTAssertEqual(userDefaultsMock.boolWasCalled, 1)
        XCTAssertEqual(userDefaultsMock.boolReceivedKey, "hasLaunchedBefore")
        XCTAssertEqual(fetchServiceMock.wasCalled, 1)
    }
    
    func testLoadListFirstLaunchSuccessPresentsListAndSavesLocally() {
        // Given
        userDefaultsMock.boolStub = false
        let items = [
            ListItem(id: 1, todo: "First", completed: false),
            ListItem(id: 2, todo: "Second", completed: true)
        ]
        let list = List(todos: items)
        fetchServiceMock.listStub = list
        
        // When
        interactor.loadList()
        
        // Then
        XCTAssertEqual(localStorageMock.rewriteAllWasCalled, 1)
        XCTAssertEqual(localStorageMock.rewriteAllReceivedList, items)
        XCTAssertEqual(userDefaultsMock.setWasCalled, 1)
        XCTAssertEqual(userDefaultsMock.setReceivedKey, "hasLaunchedBefore")
        XCTAssertEqual(userDefaultsMock.setReceivedValue as? Bool, true)
        XCTAssertEqual(presenterMock.presentListWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListReceivedList, items)
    }
    
    func testLoadListFirstLaunchFetchReturnsErrorPresentsError() {
        // Given
        userDefaultsMock.boolStub = false
        let expectedError = NSError(domain: "test", code: 42)
        fetchServiceMock.errorStub = expectedError
        
        // When
        interactor.loadList()
        
        // Then
        XCTAssertEqual(presenterMock.presentErrorWasCalled, 1)
        XCTAssertEqual(presenterMock.presentErrorReceivedError as? NSError, expectedError)
        XCTAssertEqual(presenterMock.presentListWasCalled, 0)
    }
    
    func testLoadListFirstLaunchFetchReturnsNilListPresentsNilListError() {
        // Given
        userDefaultsMock.boolStub = false
        fetchServiceMock.listStub = nil
        fetchServiceMock.errorStub = nil
        
        // When
        interactor.loadList()
        
        // Then
        XCTAssertEqual(presenterMock.presentErrorWasCalled, 1)
        XCTAssertTrue(presenterMock.presentErrorReceivedError is ListInteractorError)
        XCTAssertEqual(presenterMock.presentListWasCalled, 0)
    }
    
    func testLoadListNotFirstLaunchLoadsFromLocalStorage() {
        // Given
        userDefaultsMock.boolStub = true
        let items = [ListItem(id: 1, todo: "Local item", completed: true)]
        localStorageMock.fetchAllStub = items
        
        // When
        interactor.loadList()
        
        // Then
        XCTAssertEqual(fetchServiceMock.wasCalled, 0)
        XCTAssertEqual(localStorageMock.fetchAllWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListReceivedList, items)
    }
    
    func testLoadListNotFirstLaunchLocalStorageThrowsPresentsError() {
        // Given
        userDefaultsMock.boolStub = true
        let expectedError = NSError(domain: "storage", code: 1)
        localStorageMock.fetchAllErrorStub = expectedError
        
        // When
        interactor.loadList()
        
        // Then
        XCTAssertEqual(presenterMock.presentErrorWasCalled, 1)
        XCTAssertEqual(presenterMock.presentErrorReceivedError as? NSError, expectedError)
        XCTAssertEqual(presenterMock.presentListWasCalled, 0)
    }
    
    // MARK: - setItem
    
    func testSetItemUpdatesAndReloadsList() {
        // Given
        userDefaultsMock.boolStub = true
        let existingItem = ListItem(id: 5, todo: "Do something", completed: false)
        localStorageMock.fetchItemStub = existingItem
        let reloadedItems = [ListItem(id: 5, todo: "Do something", completed: true)]
        localStorageMock.fetchAllStub = reloadedItems
        
        // When
        interactor.setItem(completed: true, id: 5)
        
        // Then
        XCTAssertEqual(localStorageMock.fetchItemWasCalled, 1)
        XCTAssertEqual(localStorageMock.fetchItemReceivedID, 5)
        XCTAssertEqual(localStorageMock.updateWasCalled, 1)
        XCTAssertEqual(localStorageMock.updateReceivedItem?.id, 5)
        XCTAssertEqual(localStorageMock.updateReceivedItem?.todo, "Do something")
        XCTAssertEqual(localStorageMock.updateReceivedItem?.completed, true)
        XCTAssertEqual(localStorageMock.fetchAllWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListReceivedList, reloadedItems)
    }
    
    func testSetItemWhenItemNotFoundDoesNothing() {
        // Given
        localStorageMock.fetchItemStub = nil
        
        // When
        interactor.setItem(completed: true, id: 999)
        
        // Then
        XCTAssertEqual(localStorageMock.fetchItemWasCalled, 1)
        XCTAssertEqual(localStorageMock.updateWasCalled, 0)
        XCTAssertEqual(presenterMock.presentListWasCalled, 0)
    }
    
    // MARK: - updateSearchResults
    
    func testUpdateSearchResultsWithEmptyRequestPresentsFullList() {
        // Given
        let items = [
            ListItem(id: 1, todo: "Buy milk", completed: false),
            ListItem(id: 2, todo: "Walk the dog", completed: true)
        ]
        localStorageMock.fetchAllStub = items
        
        // When
        interactor.updateSearchResults(for: "")
        
        // Then
        XCTAssertEqual(localStorageMock.fetchAllWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListReceivedList, items)
    }
    
    func testUpdateSearchResultsFiltersListByRequest() {
        // Given
        let items = [
            ListItem(id: 1, todo: "Buy milk", completed: false),
            ListItem(id: 2, todo: "Walk the dog", completed: true),
            ListItem(id: 3, todo: "Buy bread", completed: false)
        ]
        localStorageMock.fetchAllStub = items
        
        // When
        interactor.updateSearchResults(for: "Buy")
        
        // Then
        XCTAssertEqual(presenterMock.presentListWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListReceivedList.count, 2)
        XCTAssertEqual(presenterMock.presentListReceivedList[0].id, 1)
        XCTAssertEqual(presenterMock.presentListReceivedList[1].id, 3)
    }
    
    func testUpdateSearchResultsCaseInsensitive() {
        // Given
        let items = [
            ListItem(id: 1, todo: "Buy milk", completed: false),
            ListItem(id: 2, todo: "Walk the dog", completed: true)
        ]
        localStorageMock.fetchAllStub = items
        
        // When
        interactor.updateSearchResults(for: "buy")
        
        // Then
        XCTAssertEqual(presenterMock.presentListReceivedList.count, 1)
        XCTAssertEqual(presenterMock.presentListReceivedList.first?.id, 1)
    }
    
    func testUpdateSearchResultsNoMatchPresentsEmptyList() {
            // Given
            let items = [
                ListItem(id: 1, todo: "Buy milk", completed: false)
            ]
            localStorageMock.fetchAllStub = items
            
            // When
            interactor.updateSearchResults(for: "nonexistent")
            
            // Then
            XCTAssertEqual(presenterMock.presentListWasCalled, 1)
            XCTAssertTrue(presenterMock.presentListReceivedList.isEmpty)
        }
        
    func testUpdateSearchResultsFetchAllThrowsPresentsError() {
        // Given
        let expectedError = NSError(domain: "storage", code: 2)
        localStorageMock.fetchAllErrorStub = expectedError
        
        // When
        interactor.updateSearchResults(for: "test")
        
        // Then
        XCTAssertEqual(presenterMock.presentErrorWasCalled, 1)
        XCTAssertEqual(presenterMock.presentErrorReceivedError as? NSError, expectedError)
        XCTAssertEqual(presenterMock.presentListWasCalled, 0)
    }
        
    // MARK: - addItem
            
    func testAddItemPresentsAddingWithNextID() {
        // Given
        let items = [
            ListItem(id: 3, todo: "First", completed: false),
            ListItem(id: 7, todo: "Second", completed: true),
            ListItem(id: 5, todo: "Third", completed: false)
        ]
        localStorageMock.fetchAllStub = items
        
        // When
        interactor.addItem()
        
        // Then
        XCTAssertEqual(localStorageMock.fetchAllWasCalled, 1)
        XCTAssertEqual(presenterMock.presentAddingItemWasCalled, 1)
        XCTAssertEqual(presenterMock.presentAddingItemReceivedID, 8)
    }

    func testAddItemEmptyListPresentsIDTwo() {
        // Given
        localStorageMock.fetchAllStub = []
        
        // When
        interactor.addItem()
        
        // Then
        XCTAssertEqual(presenterMock.presentAddingItemWasCalled, 1)
        XCTAssertEqual(presenterMock.presentAddingItemReceivedID, 2)
    }

    func testAddItemFetchAllThrowsPresentsError() {
        // Given
        let expectedError = NSError(domain: "storage", code: 3)
        localStorageMock.fetchAllErrorStub = expectedError
        
        // When
        interactor.addItem()
        
        // Then
        XCTAssertEqual(presenterMock.presentErrorWasCalled, 1)
        XCTAssertEqual(presenterMock.presentErrorReceivedError as? NSError, expectedError)
        XCTAssertEqual(presenterMock.presentAddingItemWasCalled, 0)
    }

    // MARK: - editItem

    func testEditItemPresentsEditingWithItem() {
        // Given
        let item = ListItem(id: 10, todo: "Edit me", completed: false)
        localStorageMock.fetchItemStub = item
        
        // When
        interactor.editItem(with: 10)
        
        // Then
        XCTAssertEqual(localStorageMock.fetchItemWasCalled, 1)
        XCTAssertEqual(localStorageMock.fetchItemReceivedID, 10)
        XCTAssertEqual(presenterMock.presentEditingWasCalled, 1)
        XCTAssertEqual(presenterMock.presentEditingReceivedItem?.id, 10)
        XCTAssertEqual(presenterMock.presentEditingReceivedItem?.todo, "Edit me")
    }

    func testEditItemWhenItemNotFoundDoesNothing() {
        // Given
        localStorageMock.fetchItemStub = nil
        
        // When
        interactor.editItem(with: 999)
        
        // Then
        XCTAssertEqual(localStorageMock.fetchItemWasCalled, 1)
        XCTAssertEqual(presenterMock.presentEditingWasCalled, 0)
    }

    // MARK: - shareItem

    func testShareItemPresentsSharingWithDescription() {
        // Given
        let item = ListItem(id: 3, todo: "Share this task", completed: true)
        localStorageMock.fetchItemStub = item
        
        // When
        interactor.shareItem(with: 3)
        
        // Then
        XCTAssertEqual(localStorageMock.fetchItemWasCalled, 1)
        XCTAssertEqual(localStorageMock.fetchItemReceivedID, 3)
        XCTAssertEqual(presenterMock.presentSharingItemWasCalled, 1)
        XCTAssertEqual(presenterMock.presentSharingItemReceivedDescription, "Share this task")
    }
        
    func testShareItemWhenItemNotFoundDoesNothing() {
        // Given
        localStorageMock.fetchItemStub = nil
        
        // When
        interactor.shareItem(with: 999)
        
        // Then
        XCTAssertEqual(localStorageMock.fetchItemWasCalled, 1)
        XCTAssertEqual(presenterMock.presentSharingItemWasCalled, 0)
    }
    
    // MARK: - deleteItem
    
    func testDeleteItemDeletesAndReloadsList() {
        // Given
        let remainingItems = [ListItem(id: 2, todo: "Remaining", completed: false)]
        localStorageMock.fetchAllStub = remainingItems
        
        // When
        interactor.deleteItem(with: 1)
        
        // Then
        XCTAssertEqual(localStorageMock.deleteItemWasCalled, 1)
        XCTAssertEqual(localStorageMock.deleteItemReceivedID, 1)
        XCTAssertEqual(localStorageMock.fetchAllWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListWasCalled, 1)
        XCTAssertEqual(presenterMock.presentListReceivedList, remainingItems)
    }
}
