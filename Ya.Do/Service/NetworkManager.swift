//
//  NetworkManager.swift
//  Ya.Do
//
//  Created by msc on 07.07.2021.
//

import Foundation
import DevToDoPod

class NetworkManager {
    private let netService = NetworkService()
    func fetchItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        netService.getTasks { (result) in
            switch result {
            case .success(let netItems):
                let serverTasks = intoToDoItem(from: netItems)
                completion(.success(serverTasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func uploadItem( item: ToDoItem) {
        netService.postItem(item: intoNetworkModel(from: item))
    }
    func updateItem(item: ToDoItem) {
        netService.updateItem(item: intoNetworkModel(from: item))
    }

    func deleteItem(at id: String) {
        netService.deleteItem(at: id)
    }
}
