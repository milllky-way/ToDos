//
//  ListItemFactory.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import UIKit

struct ListItemFactory {
    func build(with context: Context) -> ListItemViewController {
        let presenter = ListItemPresenter()
        let interactor = ListItemInteractor(
            context: context,
            presenter: presenter,
            localStorage: LocalStorage.shared
        )
        let controller = ListItemViewController(interactor: interactor)
        presenter.viewController = controller
        return controller
    }
}

extension ListItemFactory {
    enum Context {
        case add(id: Int)
        case edit(item: ListItem)
    }
}
