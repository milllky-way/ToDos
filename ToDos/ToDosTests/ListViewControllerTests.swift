//
//  ListViewControllerTests.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import XCTest

@testable import ToDos

@MainActor
final class ListViewControllerTests: XCTestCase {
    var viewController: ListViewController!
    
    var interactorMock: ListBusinessLogicMock!
    
    override func setUp() {
        super.setUp()
        interactorMock = ListBusinessLogicMock()
        viewController = ListViewController(interactor: interactorMock)
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        interactorMock = nil
        viewController = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // Then
        XCTAssertEqual(interactorMock.loadListWasCalled, 1)
    }
    
    func testDisplayLoadingState() {
        // Given
        guard let activityIndicator: UIActivityIndicatorView = Mirror.reflectProperty(
            from: viewController!,
            name: "activityIndicatorView"
        ) else {
            XCTFail("activityIndicatorView not found")
            return
        }
        XCTAssertTrue(activityIndicator.isHidden)
        
        // When
        viewController.displayLoadingState()
        
        // Then
        XCTAssertFalse(activityIndicator.isHidden)
    }
    
    func testDisplayList() throws {
        // Given
        guard let activityIndicator: UIActivityIndicatorView = Mirror.reflectProperty(
            from: viewController!,
            name: "activityIndicatorView"
        ) else {
            XCTFail("activityIndicatorView not found")
            return
        }
        guard let counterLabel: UILabel = Mirror.reflectProperty(
            from: viewController!,
            name: "counterLabel"
        ) else {
            XCTFail("counterLabel not found")
            return
        }
        
        let viewModel = ListViewModel(
            list: [],
            toolbarText: "3 задачи"
        )
        
        // When
        viewController.displayList(viewModel)
        
        // Then
        XCTAssertTrue(activityIndicator.isHidden)
        XCTAssertEqual(counterLabel.text, viewModel.toolbarText)
    }
    
    func testUpdateSearchResults() {
        // Given
        let searchController = UISearchController()
        searchController.searchBar.text = "test query"
        
        // When
        viewController.updateSearchResults(for: searchController)
        
        // Then
        XCTAssertEqual(interactorMock.updateSearchResultsWasCalled, 1)
        XCTAssertEqual(interactorMock.updateSearchResultsReceivedRequest, "test query")
    }
    
    func testItemDidSave() {
        // When
        viewController.itemDidSave()
        // Then
        XCTAssertEqual(interactorMock.loadListWasCalled, 2)
    }
}
