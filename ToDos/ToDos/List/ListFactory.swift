//
//  ListFactory.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import Foundation

struct ListFactory {
    func build() -> ListViewController {
        let presenter = ListPresenter(router: Router.shared)
        let interactor = ListInteractor(
            presenter: presenter,
            userDefaults: UserDefaults.standard,
            fetchService: FetchListService(),
            localStorage: LocalStorage.shared
        )
        let listController = ListViewController(interactor: interactor)
        presenter.viewController = listController
        return listController
    }
}
