//
//  List.swift
//  ToDos
//
//  Created by Дарья Саитова on 02.04.2026.
//

import Foundation

/// Модель списка задач, который приходит по запросу `FetchListService`.
struct List: Decodable {
    /// Список задач.
    let todos: [ListItem]
}
