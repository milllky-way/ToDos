//
//  ListInteractor.swift
//  ToDos
//
//  Created by Дарья Саитова on 08.04.2026.
//

import Foundation

/// Интерфейс бизнес-логики экрана списка задач.
protocol ListBusinessLogic: AnyObject {
    func loadList()
    func setItem(completed: Bool, id: Int)
    func updateSearchResults(for request: String)
    func addItem()
    func editItem(with id: Int)
    func shareItem(with id: Int)
    func deleteItem(with id: Int)
}

final class ListInteractor: ListBusinessLogic {
    private let presenter: ListPresentationLogic
    private let userDefaults: ContainsValueByKey
    private let fetchService: FetchesList
    private let localStorage: StoresLocalData
    
    init(
        presenter: ListPresentationLogic,
        userDefaults: ContainsValueByKey,
        fetchService: FetchesList,
        localStorage: StoresLocalData
    ) {
        self.presenter = presenter
        self.userDefaults = userDefaults
        self.fetchService = fetchService
        self.localStorage = localStorage
    }
    
    func loadList() {
        if !userDefaults.bool(forKey: "hasLaunchedBefore") {
            fetchList()
        } else {
            loadListFromLocalStorage()
        }
    }
    
    private func fetchList() {
        fetchService.fetchList { [weak self] list, error in
            if let error { self?.presenter.present(error: error) }
            else if let list {
                self?.localStorage.rewriteAll(list.todos)
                self?.userDefaults.set(true, forKey: "hasLaunchedBefore")
                self?.presenter.present(list: list.todos)
            } else { self?.presenter.present(error: ListInteractorError.nilList) }
        }
    }
    
    private func loadListFromLocalStorage() {
        do {
            let list = try localStorage.fetchAll()
            presenter.present(list: list)
        } catch {
            presenter.present(error: error)
        }
    }
    
    func setItem(completed: Bool, id: Int) {
        guard let item = localStorage.fetchItem(with: id) else { return }
        let newItem = ListItem(
            id: id,
            todo: item.todo,
            completed: completed
        )
        localStorage.update(newItem) { [weak self] in
            self?.loadListFromLocalStorage()
        }
    }
    
    func updateSearchResults(for request: String) {
        do {
            let list = try localStorage.fetchAll()
            presentSearchResults(for: request, list: list)
        } catch {
            presenter.present(error: error)
        }
    }
    
    private func presentSearchResults(for request: String, list: [ListItem]) {
        if request.isEmpty {
            presenter.present(list: list)
        } else {
            let filteredList = list.filter { item in
                item.todo.localizedCaseInsensitiveContains(request)
            }
            presenter.present(list: filteredList)
        }
    }
    
    func addItem() {
        do {
            let maxID = try localStorage.fetchAll().map(\.id).max() ?? 1
            presenter.presentAddingItem(id: maxID + 1)
        } catch {
            presenter.present(error: error)
        }
    }
    
    func editItem(with id: Int) {
        guard let item = localStorage.fetchItem(with: id) else { return }
        presenter.presentEditing(item: item)
    }
    
    func shareItem(with id: Int) {
        guard let item = localStorage.fetchItem(with: id) else { return }
        presenter.presentSharingItem(with: item.todo)
    }
    
    func deleteItem(with id: Int) {
        localStorage.deleteItem(with: id) { [weak self] in
            self?.loadListFromLocalStorage()
        }
    }
}

// MARK: - Error

enum ListInteractorError: Error {
    var localizedDescription: String {
        switch self {
        case .nilList:
            "Полученный от запроса список равен nil"
        }
    }
    
    case nilList
}

// MARK: - Mock

final class ListBusinessLogicMock: ListBusinessLogic {
    var loadListWasCalled = 0
    
    func loadList() {
        loadListWasCalled += 1
    }
    
    var setItemWasCalled = 0
    var setItemReceivedCompleted: Bool?
    var setItemReceivedID: Int?
    
    func setItem(completed: Bool, id: Int) {
        setItemWasCalled += 1
        setItemReceivedCompleted = completed
        setItemReceivedID = id
    }
    
    var updateSearchResultsWasCalled = 0
    var updateSearchResultsReceivedRequest = ""
    
    func updateSearchResults(for request: String) {
        updateSearchResultsWasCalled += 1
        updateSearchResultsReceivedRequest = request
    }
    
    var addItemWasCalled = 0
    
    func addItem() {
        addItemWasCalled += 1
    }
    
    var editItemWasCalled = 0
    var editItemReceivedID: Int?
    
    func editItem(with id: Int) {
        editItemWasCalled += 1
        editItemReceivedID = id
    }
    
    var shareItemWasCalled = 0
    var shareItemReceivedID: Int?
    
    func shareItem(with id: Int) {
        shareItemWasCalled += 1
        shareItemReceivedID = id
    }
    
    var deleteItemWasCalled = 0
    var deleteItemReceivedID: Int?
    
    func deleteItem(with id: Int) {
        deleteItemWasCalled += 1
        deleteItemReceivedID = id
    }
}
