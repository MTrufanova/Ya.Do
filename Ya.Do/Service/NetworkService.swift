//
//  NetworkService.swift
//  Ya.Do
//
//  Created by msc on 27.06.2021.
//

import Foundation

protocol NetworkServiceProtocol {

    func getTasks(completion: @escaping (Result<[ToDoItem], NetworkingServiceError>) -> Void)
    func postItem(item: ToDoItem, completion: @escaping (Result<ToDoItem, NetworkingServiceError>) -> Void )
    // func putTasks(onResult: @escaping (Result<[NetworkingModel], Error>) -> Void)
    func deleteItem(at id: String, completion: @escaping (Result<ToDoItem, NetworkingServiceError>) -> Void )
    func updateItem(item: ToDoItem, completion: @escaping (Result<ToDoItem, NetworkingServiceError>) -> Void)
}
