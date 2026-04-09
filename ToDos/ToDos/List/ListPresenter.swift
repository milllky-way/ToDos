//
//  ListPresenter.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import Foundation

/// Интерфейс для презентера экрана задач.
protocol ListPresentationLogic: AnyObject {
    func present(error: Error)
    func present(list: [ListItem])
    func presentAddingItem(id: Int)
    func presentEditing(item: ListItem)
    func presentSharingItem(with description: String)
}

final class ListPresenter: ListPresentationLogic {
    weak var viewController: ListDisplayLogic?
    
    private let router: ListRoutes
    
    init(router: ListRoutes) {
        self.router = router
    }
    
    func present(error: any Error) {
        guard let viewController else { return }
        router.navigateToErrorAlert(from: viewController, message: error.localizedDescription)
    }
    
    func present(list: [ListItem]) {
        let viewModels = list.map { item in
            ListItemViewModel(
                id: item.id,
                title: "Задача №\(item.id)",
                todo: item.todo,
                isCompleted: item.completed
            )
        }
        let toolbarText = toolbarText(from: list.count)
        viewController?.displayList(
            ListViewModel(
                list: viewModels,
                toolbarText: toolbarText
            )
        )
    }
    
    private func toolbarText(from itemsCount: Int) -> String {
        let mod10 = itemsCount % 10
        let mod100 = itemsCount % 100
        if mod10 == 1 && mod100 != 11 { return "\(itemsCount) задача" }
        if (2...4).contains(mod10) && !(12...14).contains(mod100) { return "\(itemsCount) задачи" }
        return "\(itemsCount) задач"
    }
    
    func presentAddingItem(id: Int) {
        guard let viewController else { return }
        router.navigateToAddItemView(from: viewController, itemID: id)
    }
    
    func presentEditing(item: ListItem) {
        guard let viewController else { return }
        router.navigateToEditItemView(from: viewController, item: item)
    }
    
    func presentSharingItem(with description: String) {
        guard let viewController else { return }
        router.navigateToShareView(from: viewController, sharingText: description)
    }
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
