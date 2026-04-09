//
//  Router.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import UIKit

final class Router {
    static let shared = Router()
    
    private init() { }
}

// MARK: - ListRoutes

extension Router: ListRoutes {
    func navigateToErrorAlert(from viewController: UIViewController, message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
    func navigateToAddItemView(from viewController: ListItemViewControllerDelegate, itemID id: Int) {
        let addViewController = ListItemFactory().build(with: .add(id: id))
        addViewController.delegate = viewController
        let navigationController = UINavigationController(rootViewController: addViewController)
        viewController.present(navigationController, animated: true)
    }
    
    func navigateToEditItemView(from viewController: ListItemViewControllerDelegate, item: ListItem) {
        let editViewController = ListItemFactory().build(with: .edit(item: item))
        editViewController.delegate = viewController
        let navigationController = UINavigationController(rootViewController: editViewController)
        viewController.present(navigationController, animated: true)
    }
    
    func navigateToShareView(from viewController: UIViewController, sharingText text: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        viewController.present(activityViewController, animated: true)
    }
}
