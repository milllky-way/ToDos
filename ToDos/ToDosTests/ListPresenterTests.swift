//
//  ListPresenterTests.swift
//  ToDosTests
//
//  Created by Дарья Саитова on 09.04.2026.
//

import XCTest

@testable import ToDos

@MainActor
final class ListPresenterTests: XCTestCase {
    var presenter: ListPresenter!
    
    var viewControllerMock: ListDisplayLogicMock!
    var routerMock: ListRoutesMock!
    
    override func setUp() {
        super.setUp()
        routerMock = ListRoutesMock()
        viewControllerMock = ListDisplayLogicMock()
        presenter = ListPresenter(router: routerMock)
        presenter.viewController = viewControllerMock
    }
    
    override func tearDown() {
        routerMock = nil
        viewControllerMock = nil
        presenter = nil
        super.tearDown()
    }
    
    // MARK: - present(error:)
    
    func testPresentErrorNavigatesToErrorAlert() {
        // Given
        let error = NSError(domain: "test", code: 42, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
        
        // When
        presenter.present(error: error)
        
        // Then
        XCTAssertEqual(routerMock.navigateToErrorAlertWasCalled, 1)
        XCTAssertTrue(routerMock.navigateToErrorAlertReceivedViewController === viewControllerMock)
        XCTAssertEqual(routerMock.navigateToErrorAlertReceivedMessage, "Something went wrong")
    }
    
    func testPresentErrorWhenViewControllerIsNilDoesNothing() {
        // Given
        presenter.viewController = nil
        let error = NSError(domain: "test", code: 1)
        
        // When
        presenter.present(error: error)
        
        // Then
        XCTAssertEqual(routerMock.navigateToErrorAlertWasCalled, 0)
    }
    
    // MARK: - present(list:)
    
    func testPresentListDisplaysCorrectViewModels() {
        // Given
        let items = [
            ListItem(id: 1, todo: "Buy milk", completed: false),
            ListItem(id: 2, todo: "Walk the dog", completed: true)
        ]
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListWasCalled, 1)
        
        let viewModel = viewControllerMock.displayListReceivedViewModel
        XCTAssertEqual(viewModel?.list.count, 2)
        
        XCTAssertEqual(viewModel?.list[0].id, 1)
        XCTAssertEqual(viewModel?.list[0].title, "Задача №1")
        XCTAssertEqual(viewModel?.list[0].todo, "Buy milk")
        XCTAssertEqual(viewModel?.list[0].isCompleted, false)
        
        XCTAssertEqual(viewModel?.list[1].id, 2)
        XCTAssertEqual(viewModel?.list[1].title, "Задача №2")
        XCTAssertEqual(viewModel?.list[1].todo, "Walk the dog")
        XCTAssertEqual(viewModel?.list[1].isCompleted, true)
    }
    
    func testPresentEmptyListDisplaysEmptyViewModel() {
        // When
        presenter.present(list: [])
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListWasCalled, 1)
        
        let viewModel = viewControllerMock.displayListReceivedViewModel
        XCTAssertEqual(viewModel?.list.count, 0)
        XCTAssertEqual(viewModel?.toolbarText, "0 задач")
    }
    
    func testPresentListWhenViewControllerIsNilDoesNothing() {
        // Given
        presenter.viewController = nil
        let items = [ListItem(id: 1, todo: "Test", completed: false)]
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListWasCalled, 0)
    }
    
    // MARK: - toolbarText (склонение)
    
    func testToolbarText1Task() {
        // Given
        let items = [ListItem(id: 1, todo: "One", completed: false)]
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "1 задача")
    }
    
    func testToolbarText2Tasks() {
        // Given
        let items = (1...2).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "2 задачи")
    }
    
    func testToolbarText3Tasks() {
        // Given
        let items = (1...3).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "3 задачи")
    }
    
    func testToolbarText4Tasks() {
        // Given
        let items = (1...4).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "4 задачи")
    }
    
    func testToolbarText5Tasks() {
        // Given
        let items = (1...5).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "5 задач")
    }
    
    func testToolbarText10Tasks() {
        // Given
        let items = (1...10).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "10 задач")
    }
    
    func testToolbarText11Tasks() {
        // Given
        let items = (1...11).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "11 задач")
    }
    
    func testToolbarText12Tasks() {
        // Given
        let items = (1...12).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "12 задач")
    }
    
    func testToolbarText14Tasks() {
        // Given
        let items = (1...14).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "14 задач")
    }
    
    func testToolbarText20Tasks() {
        // Given
        let items = (1...20).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "20 задач")
    }
    
    func testToolbarText21Tasks() {
        // Given
        let items = (1...21).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "21 задача")
    }
    
    func testToolbarText22Tasks() {
        // Given
        let items = (1...22).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "22 задачи")
    }
    
    func testToolbarText111Tasks() {
        // Given
        let items = (1...111).map { ListItem(id: $0, todo: "Item \($0)", completed: false) }
        
        // When
        presenter.present(list: items)
        
        // Then
        XCTAssertEqual(viewControllerMock.displayListReceivedViewModel?.toolbarText, "111 задач")
    }
    
    // MARK: - presentAddingItem
    
    func testPresentAddingItemNavigatesToAddItemView() {
        // When
        presenter.presentAddingItem(id: 5)
        
        // Then
        XCTAssertEqual(routerMock.navigateToAddItemViewWasCalled, 1)
        XCTAssertTrue(routerMock.navigateToAddItemViewReceivedViewController === viewControllerMock)
        XCTAssertEqual(routerMock.navigateToAddItemViewReceivedID, 5)
    }
    
    func testPresentAddingItemWhenViewControllerIsNilDoesNothing() {
        // Given
        presenter.viewController = nil
        
        // When
        presenter.presentAddingItem(id: 5)
        
        // Then
        XCTAssertEqual(routerMock.navigateToAddItemViewWasCalled, 0)
    }
    
    // MARK: - presentEditing
    
    func testPresentEditingNavigatesToEditItemView() {
        // Given
        let item = ListItem(id: 3, todo: "Edit me", completed: true)
        
        // When
        presenter.presentEditing(item: item)
        
        // Then
        XCTAssertEqual(routerMock.navigateToEditItemViewWasCalled, 1)
        XCTAssertTrue(routerMock.navigateToEditItemViewReceivedViewController === viewControllerMock)
        XCTAssertEqual(routerMock.navigateToEditItemViewReceivedItem?.id, 3)
        XCTAssertEqual(routerMock.navigateToEditItemViewReceivedItem?.todo, "Edit me")
        XCTAssertEqual(routerMock.navigateToEditItemViewReceivedItem?.completed, true)
    }
    
    func testPresentEditingWhenViewControllerIsNilDoesNothing() {
        // Given
        presenter.viewController = nil
        let item = ListItem(id: 3, todo: "Edit me", completed: false)
        
        // When
        presenter.presentEditing(item: item)
        
        // Then
        XCTAssertEqual(routerMock.navigateToEditItemViewWasCalled, 0)
    }
    
    // MARK: - presentSharingItem
    
    func testPresentSharingItemNavigatesToShareView() {
        // When
        presenter.presentSharingItem(with: "Share this text")
        
        // Then
        XCTAssertEqual(routerMock.navigateToShareViewWasCalled, 1)
        XCTAssertTrue(routerMock.navigateToShareViewReceivedViewController === viewControllerMock)
        XCTAssertEqual(routerMock.navigateToShareViewReceivedText, "Share this text")
    }
    
    func testPresentSharingItemWhenViewControllerIsNilDoesNothing() {
        // Given
        presenter.viewController = nil
        
        // When
        presenter.presentSharingItem(with: "Share this text")
        
        // Then
        XCTAssertEqual(routerMock.navigateToShareViewWasCalled, 0)
    }
}
