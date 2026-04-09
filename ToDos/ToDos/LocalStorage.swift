//
//  LocalStorage.swift
//  ToDos
//
//  Created by Дарья Саитова on 06.04.2026.
//

import CoreData

/// Интерфейс локального хранилища.
protocol StoresLocalData: AnyObject {
    /// Полностью перезаписывает список задач.
    func rewriteAll(_ list: [ListItem])
    /// Возвращает список задач.
    func fetchAll() throws -> [ListItem]
    /// Возвращает задачу с `id` или `nil`, если такой задачи нет в хранилище.
    func fetchItem(with id: Int) -> ListItem?
    /// Создаёт и сохраняет новую задачу.
    func add(_ item: ListItem, completion: @escaping () -> Void)
    /// Обновляет данные существующей задачи.
    func update(_ item: ListItem, completion: @escaping () -> Void)
    /// Удаляет задачу с `id`.
    func deleteItem(with id: Int, completion: @escaping () -> Void)
}

final class LocalStorage {
    static let shared = LocalStorage()
    
    private let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "ToDos")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: - StoresLocalData

extension LocalStorage: StoresLocalData {
    func rewriteAll(_ list: [ListItem]) {
        container.performBackgroundTask { [weak container] context in
            guard let container else { return }
            let deleteRequest = NSBatchDeleteRequest(
                fetchRequest: NSFetchRequest(entityName: "ListItemEntity")
            )
            deleteRequest.resultType = .resultTypeObjectIDs
            let result = try? context.execute(deleteRequest) as? NSBatchDeleteResult
            let deletedIDs = result?.result as? [NSManagedObjectID] ?? []
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: [NSDeletedObjectsKey: deletedIDs],
                into: [container.viewContext]
            )
            for item in list {
                _ = ListItemLocalStorageEntity(listItem: item, context: context)
            }
            try? context.save()
        }
    }
    
    func fetchAll() throws -> [ListItem] {
        let request = NSFetchRequest<ListItemLocalStorageEntity>(entityName: "ListItemEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let entities = try container.viewContext.fetch(request)
        return entities.map { entity in
            ListItem(
                id: Int(entity.id),
                todo: entity.todo,
                completed: entity.completed
            )
        }
    }
    
    func fetchItem(with id: Int) -> ListItem? {
        let request = NSFetchRequest<ListItemLocalStorageEntity>(entityName: "ListItemEntity")
        request.predicate = NSPredicate(format: "id == %d", Int64(id))
        request.fetchLimit = 1
        guard let entity = try? container.viewContext.fetch(request).first else { return nil }
        return ListItem(
            id: Int(entity.id),
            todo: entity.todo,
            completed: entity.completed
        )
    }
    
    func add(_ item: ListItem, completion: @escaping () -> Void) {
        container.performBackgroundTask { context in
            _ = ListItemLocalStorageEntity(listItem: item, context: context)
            try? context.save()
            DispatchQueue.main.async { completion() }
        }
    }
    
    func update(_ item: ListItem, completion: @escaping () -> Void) {
        container.performBackgroundTask { context in
            let request = NSFetchRequest<ListItemLocalStorageEntity>(entityName: "ListItemEntity")
            request.predicate = NSPredicate(format: "id == %d", Int64(item.id))
            request.fetchLimit = 1
            if let entity = try? context.fetch(request).first {
                entity.update(from: item)
                try? context.save()
            }
            DispatchQueue.main.async { completion() }
        }
    }
    
    func deleteItem(with id: Int, completion: @escaping () -> Void) {
        container.performBackgroundTask { context in
            let request = NSFetchRequest<ListItemLocalStorageEntity>(entityName: "ListItemEntity")
            request.predicate = NSPredicate(format: "id == %d", Int64(id))
            request.fetchLimit = 1
            if let entity = try? context.fetch(request).first {
                context.delete(entity)
                try? context.save()
            }
            DispatchQueue.main.async { completion() }
        }
    }
}

// MARK: - Mock

final class StoresLocalDataMock: StoresLocalData {
    var rewriteAllWasCalled = 0
    var rewriteAllReceivedList: [ListItem] = []
    
    func rewriteAll(_ list: [ListItem]) {
        rewriteAllWasCalled += 1
        rewriteAllReceivedList = list
    }
    
    var fetchAllWasCalled = 0
    var fetchAllErrorStub: Error?
    var fetchAllStub: [ListItem]!
    
    func fetchAll() throws -> [ListItem] {
        fetchAllWasCalled += 1
        if let error = fetchAllErrorStub {
            throw error
        }
        return fetchAllStub
    }
    
    var fetchItemWasCalled = 0
    var fetchItemReceivedID: Int?
    var fetchItemStub: ListItem?
    
    func fetchItem(with id: Int) -> ListItem? {
        fetchItemWasCalled += 1
        fetchItemReceivedID = id
        return fetchItemStub
    }
    
    var addWasCalled = 0
    var addReceivedItem: ListItem?
    
    func add(_ item: ListItem, completion: @escaping () -> Void) {
        addWasCalled += 1
        addReceivedItem = item
        completion()
    }
    
    var updateWasCalled = 0
    var updateReceivedItem: ListItem?
    
    func update(_ item: ListItem, completion: @escaping () -> Void) {
        updateWasCalled += 1
        updateReceivedItem = item
        completion()
    }
    
    var deleteItemWasCalled = 0
    var deleteItemReceivedID: Int?
    
    func deleteItem(with id: Int, completion: @escaping () -> Void) {
        deleteItemWasCalled += 1
        deleteItemReceivedID = id
        completion()
    }
}
