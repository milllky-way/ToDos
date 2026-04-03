//
//  FetchListService.swift
//  ToDos
//
//  Created by Дарья Саитова on 02.04.2026.
//

import Foundation

/// Интерфейс сервиса для загрузки списка задач (см. `ListItem`).
protocol FetchesList: AnyObject {
    /// Запрашивает список задач `List`.
    /// - Parameters:
    /// - completion: замыкание, которое выполнится после выполнения запроса и будет содержать `List` в случае успеха запроса или `Error`
    /// в случае неудачи.
    func fetchList(completion: @escaping (List?, Error?) -> Void)
}

final class FetchListService: FetchesList {
    func fetchList(completion: @escaping (List?, (any Error)?) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            DispatchQueue.main.async {
                completion(nil, FetchListServiceError.invalidURL)
            }
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            self?.processResult(data, error: error, completion: completion)
        }.resume()
    }
    
    private func processResult(
        _ data: Data?,
        error: Error?,
        completion: @escaping (List?, (any Error)?) -> Void
    ) {
        if let error {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        
        guard let data else {
            DispatchQueue.main.async {
                completion(nil, FetchListServiceError.emptyData)
            }
            return
        }
        
        do {
            let list = try JSONDecoder().decode(List.self, from: data)
            DispatchQueue.main.async {
                completion(list, nil)
            }
        } catch {
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
}

// MARK: - FetchListServiceError

extension FetchListService {
    enum FetchListServiceError: Error {
        case invalidURL
        case emptyData
    }
}

// MARK: - Mock

final class FetchesListMock: FetchesList {
    var wasCalled = 0
    var listStub: List?
    var errorStub: Error?
    
    func fetchList(completion: @escaping (List?, (any Error)?) -> Void) {
        wasCalled += 1
        completion(listStub, errorStub)
    }
}
