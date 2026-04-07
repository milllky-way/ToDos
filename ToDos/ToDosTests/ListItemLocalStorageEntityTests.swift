//
//  ListItemLocalStorageEntityTests.swift
//  ToDos
//
//  Created by Дарья Саитова on 07.04.2026.
//

import XCTest
import CoreData

@testable import ToDos

final class ListItemLocalStorageEntityTests: XCTestCase {
    var persistentContainer: NSPersistentContainer!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        let container = NSPersistentContainer(name: "ToDos")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        persistentContainer = container
        context = container.newBackgroundContext()
    }

    override func tearDownWithError() throws {
        persistentContainer = nil
        context = nil
    }

    func testEntityUpdate() {
        // Given
        let originalItem = ListItem(
            id: 10,
            todo: "Старая задача",
            completed: false
        )
        
        guard let entity = ListItemLocalStorageEntity(
            listItem: originalItem,
            context: context
        ) else {
            XCTFail("Не удалось создать сущность")
            return
        }

        let updatedItem = ListItem(
            id: 11,
            todo: "Обновлённая задача",
            completed: true
        )
        
        // When
        entity.update(from: updatedItem)

        // Then
        XCTAssertEqual(entity.id, 10)
        XCTAssertEqual(entity.todo, updatedItem.todo)
        XCTAssertTrue(entity.completed)
    }
}
