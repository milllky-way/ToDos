//
//  ListItemLocalStorageEntity.swift
//  ToDos
//
//  Created by Дарья Саитова on 06.04.2026.
//

import CoreData

/// CoreData-сущность для модели задачи (см. `ListItem`).
@objc(ListItemEntity)
final class ListItemLocalStorageEntity: NSManagedObject {
    /// Номер задачи.
    @NSManaged var id: Int64
    /// Описание задачи.
    @NSManaged var todo: String
    /// `true`, если задача выполнена.
    @NSManaged var completed: Bool
    
    convenience init?(listItem: ListItem, context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "ListItemEntity",
            in: context
        ) else { return nil }
        self.init(entity: entity, insertInto: context)
        self.id = Int64(listItem.id)
        self.todo = listItem.todo
        self.completed = listItem.completed
    }
    
    func update(from item: ListItem) {
        self.todo = item.todo
        self.completed = item.completed
    }
}
