//
//  ListPresenter.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import Foundation

protocol ListPresentationLogic: AnyObject {
    func present(error: Error)
    func present(list: [ListItem])
    func presentAddingItem(id: Int)
    func presentEditing(item: ListItem)
    func presentSharingItem(with description: String)
}

// MARK: - Mock

final class ListPresentationLogicMock: ListPresentationLogic {
    var presentErrorWasCalled = 0
    var presentErrorReceivedError: Error?
    
    func present(error: any Error) {
        presentErrorWasCalled += 1
        presentErrorReceivedError = error
    }
    
    var presentListWasCalled = 0
    var presentListReceivedList: [ListItem] = []
    
    func present(list: [ListItem]) {
        presentListWasCalled += 1
        presentListReceivedList = list
    }
    
    var presentAddingItemWasCalled = 0
    var presentAddingItemReceivedID: Int?
    
    func presentAddingItem(id: Int) {
        presentAddingItemWasCalled += 1
        presentAddingItemReceivedID = id
    }
    
    var presentEditingWasCalled = 0
    var presentEditingReceivedItem: ListItem?
    
    func presentEditing(item: ListItem) {
        presentEditingWasCalled += 1
        presentEditingReceivedItem = item
    }
    
    var presentSharingItemWasCalled = 0
    var presentSharingItemReceivedDescription = ""
    
    func presentSharingItem(with description: String) {
        presentSharingItemWasCalled += 1
        presentSharingItemReceivedDescription = description
    }
}
