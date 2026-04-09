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
        let listController = ListViewController(interactor: ListBusinessLogicMock())
        let rootViewController = UINavigationController(rootViewController: listController)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

