//
//  SceneDelegate.swift
//  ToDos
//
//  Created by Дарья Саитова on 02.04.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let presenter = ListPresenter(router: ListRoutesMock())
        let interactor = ListInteractor(
            presenter: presenter,
            userDefaults: UserDefaults.standard,
            fetchService: FetchListService(),
            localStorage: LocalStorage.shared
        )
        let listController = ListViewController(interactor: interactor)
        presenter.viewController = listController
        let rootViewController = UINavigationController(rootViewController: listController)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

