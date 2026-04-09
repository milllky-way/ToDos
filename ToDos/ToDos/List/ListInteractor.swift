//
//  ListInteractor.swift
//  ToDos
//
//  Created by Дарья Саитова on 08.04.2026.
//

import Foundation

protocol ListBusinessLogic: AnyObject {
    func loadList()
    func setItem(completed: Bool, id: Int)
    func updateSearchResults(for request: String)
    func addItem()
    func editItem(with id: Int)
    func shareItem(with id: Int)
    func deleteItem(with id: Int)
}

// MARK: - Mock

final class ListBusinessLogicMock: ListBusinessLogic {
    var loadListWasCalled = 0
    
    func loadList() {
        loadListWasCalled += 1
    }
    
    var setItemWasCalled = 0
    var setItemReceivedCompleted: Bool?
    var setItemReceivedID: Int?
    
    func setItem(completed: Bool, id: Int) {
        setItemWasCalled += 1
        setItemReceivedCompleted = completed
        setItemReceivedID = id
    }
    
    var updateSearchResultsWasCalled = 0
    var updateSearchResultsReceivedRequest = ""
    
    func updateSearchResults(for request: String) {
        updateSearchResultsWasCalled += 1
        updateSearchResultsReceivedRequest = request
    }
    
    var addItemWasCalled = 0
    
    func addItem() {
        addItemWasCalled += 1
    }
    
    var editItemWasCalled = 0
    var editItemReceivedID: Int?
    
    func editItem(with id: Int) {
        editItemWasCalled += 1
        editItemReceivedID = id
    }
    
    var shareItemWasCalled = 0
    var shareItemReceivedID: Int?
    
    func shareItem(with id: Int) {
        shareItemWasCalled += 1
        shareItemReceivedID = id
    }
    
    var deleteItemWasCalled = 0
    var deleteItemReceivedID: Int?
    
    func deleteItem(with id: Int) {
        deleteItemWasCalled += 1
        deleteItemReceivedID = id
    }
}
