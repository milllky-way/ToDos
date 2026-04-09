//
//  ListItemViewModel.swift
//  ToDos
//
//  Created by Дарья Саитова on 08.04.2026.
//

import Foundation

/// View model для ячейки таблицы `ListItemCell`.
struct ListItemViewModel: Hashable, Sendable {
    let id: Int
    let title: String
    let todo: String
    let isCompleted: Bool
    
    nonisolated var hashValue: Int {
        id.hashValue
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

enum ListSection: Int, CaseIterable, Hashable, Sendable {
    case main
}
