//
//  ListRoutes.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import UIKit

protocol ListRoutes: AnyObject {
    func navigateToErrorAlert(from viewController: UIViewController, message: String)
    func navigateToAddItemView(from viewController: UIViewController, itemID id: Int)
    func navigateToEditItemView(from viewController: UIViewController, item: ListItem)
    func navigateToShareView(from viewController: UIViewController, sharingText text: String)
}

// MARK: - Mock

final class ListRoutesMock: ListRoutes {
    var navigateToErrorAlertWasCalled = 0
    var navigateToErrorAlertReceivedViewController: UIViewController?
    var navigateToErrorAlertReceivedMessage = ""
    
    func navigateToErrorAlert(from viewController: UIViewController, message: String) {
        navigateToErrorAlertWasCalled += 1
        navigateToErrorAlertReceivedViewController = viewController
        navigateToErrorAlertReceivedMessage = message
    }
    
    var navigateToAddItemViewWasCalled = 0
    var navigateToAddItemViewReceivedViewController: UIViewController?
    var navigateToAddItemViewReceivedID: Int?
    
    func navigateToAddItemView(from viewController: UIViewController, itemID id: Int) {
        navigateToAddItemViewWasCalled += 1
        navigateToAddItemViewReceivedViewController = viewController
        navigateToAddItemViewReceivedID = id
    }
    
    var navigateToEditItemViewWasCalled = 0
    var navigateToEditItemViewReceivedViewController: UIViewController?
    var navigateToEditItemViewReceivedItem: ListItem?
    
    func navigateToEditItemView(from viewController: UIViewController, item: ListItem) {
        navigateToEditItemViewWasCalled += 1
        navigateToEditItemViewReceivedViewController = viewController
        navigateToEditItemViewReceivedItem = item
    }
    
    var navigateToShareViewWasCalled = 0
    var navigateToShareViewReceivedViewController: UIViewController?
    var navigateToShareViewReceivedText = ""
    
    func navigateToShareView(from viewController: UIViewController, sharingText text: String) {
        navigateToShareViewWasCalled += 1
        navigateToShareViewReceivedViewController = viewController
        navigateToShareViewReceivedText = text
    }
}
