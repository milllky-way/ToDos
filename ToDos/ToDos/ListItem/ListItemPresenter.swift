//
//  ListItemPresenter.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import Foundation

protocol ListItemPresentationLogic: AnyObject {
    func presentAddItemTitle(forItemWith id: Int)
    func presentEditItemTitle(for item: ListItem)
    func present(text: String)
    func presentSaving()
}

final class ListItemPresenter: ListItemPresentationLogic {
    weak var viewController: ListItemDisplayLogic?
    
    func presentAddItemTitle(forItemWith id: Int) {
        viewController?.display(title: "Задача №\(id)")
    }
    
    func presentEditItemTitle(for item: ListItem) {
        viewController?.display(title: "Задача №\(item.id)")
    }
    
    func present(text: String) {
        viewController?.display(text: text)
    }
    
    func presentSaving() {
        viewController?.displaySaving()
    }
}
