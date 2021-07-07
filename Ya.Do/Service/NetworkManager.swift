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
   // private var serverTasks = [ToDoItem]()

    func fetchItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        netService.getTasks { (result) in
            switch result {
            case .success(let netItems):
               // do {
                   let serverTasks = intoToDoItem(from: netItems)
                    completion(.success(serverTasks))
               // }
                    //self?.serverTasks = intoToDoItem(from: netItems)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
