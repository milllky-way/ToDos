//
//  ListItem.swift
//  ToDos
//
//  Created by Дарья Саитова on 02.04.2026.
//

import Foundation

/// Модель задачи, приходящей по запросу (см. `FetchListService`).
struct ListItem: Decodable, Equatable {
    /// Номер задачи.
    let id: Int
    /// Описание задачи.
    let todo: String
    /// `true`, если задача выполнена и `false` иначе.
    let completed: Bool
}
