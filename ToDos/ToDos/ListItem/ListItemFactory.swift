//
//  ListItemFactory.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import UIKit

struct ListItemFactory {
    func build(with context: Context) -> UIViewController {
        return UIViewController(nibName: nil, bundle: nil)
    }
}

extension ListItemFactory {
    enum Context {
        case add(id: Int)
        case edit(item: ListItem)
    }
}
