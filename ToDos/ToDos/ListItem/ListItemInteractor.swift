//
//  ListItemInteractor.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import Foundation

protocol ListItemBusinessLogic: AnyObject {
    func setTitle()
    func setText()
    func saveItem(with description: String)
}

final class ListItemInteractor: ListItemBusinessLogic {
    private let context: ListItemFactory.Context
    private let presenter: ListItemPresentationLogic
    private let localStorage: StoresLocalData
    
    init(
        context: ListItemFactory.Context,
        presenter: ListItemPresentationLogic,
        localStorage: StoresLocalData
    ) {
        self.context = context
        self.presenter = presenter
        self.localStorage = localStorage
    }
    
    func setTitle() {
        switch context {
        case let .add(id):
            presenter.presentAddItemTitle(forItemWith: id)
        case let .edit(item):
            presenter.presentEditItemTitle(for: item)
        }
    }
    
    func setText() {
        switch context {
        case .add:
            break
        case let .edit(item):
            presenter.present(text: item.todo)
        }
    }
    
    func saveItem(with description: String) {
        switch context {
        case let .add(id):
            let item = ListItem(id: id, todo: description, completed: false)
            localStorage.add(item) { [weak presenter] in
                presenter?.presentSaving()
            }
        case let .edit(item):
            let item = ListItem(id: item.id, todo: description, completed: item.completed)
            localStorage.update(item) { [weak presenter] in
                presenter?.presentSaving()
            }
        }
    }
}
