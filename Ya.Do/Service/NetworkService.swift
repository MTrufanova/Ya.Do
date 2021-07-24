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

class NetworkService: NetworkServiceProtocol {
    
    private let queue = DispatchQueue.global(qos: .utility)
    
    let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 30.0
        return session
    }()
    
    let token = "LTI1NDg1ODAxMTQ3MjQ1NzgxMDY"
    // MARK: - GET
    
    func getTasks(completion: @escaping (Result<[ToDoItem], NetworkingServiceError>) -> Void) {
        func complete(_ result: Result<[ToDoItem], NetworkingServiceError>) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
        queue.async { [weak self] in
            guard let self = self else { return }
            
            guard let url = Endpoint.getTasks.url else {
                complete(.failure(.failedToCreateUrl))
                return }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue( "Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            
            let task = self.session.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    complete(.failure(.networkingError(error)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, let data = data else {
                    complete(.failure(.noResponseOrData))
                    return
                }
                
                guard response.statusCode >= 200, response.statusCode < 300 else {
                    complete(.failure(.invalidStatusCode(response.statusCode)))
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let todoItemsNet = try jsonDecoder.decode([NetworkingModel].self, from: data)
                    let todoItems = try todoItemsNet.map { try ToDoItem.init(with: $0) }
                    complete(.success(todoItems))
                    print(todoItems.count)
                } catch {
                    complete(.failure(.deserializationError(error)))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - POST
    func postItem(item: ToDoItem, completion: @escaping (Result<ToDoItem, NetworkingServiceError>) -> Void ) {
        func complete(_ result: Result<ToDoItem, NetworkingServiceError>) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        queue.async { [weak self] in
            guard let self = self else { return }
            
            guard let url = Endpoint.postTask.url else {
                complete(.failure(.failedToCreateUrl))
                return }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue( "Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            
            let jsonEncoder = JSONEncoder()
            do {
                urlRequest.httpBody = try jsonEncoder.encode(item.asNetModel)
            } catch {
                complete(.failure(.serializationError(error)))
            }
            
            let task = self.session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    complete(.failure(.networkingError(error)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, let data = data else {
                    complete(.failure(.noResponseOrData))
                    return
                }
                
                guard response.statusCode >= 200, response.statusCode < 300 else {
                    complete(.failure(.invalidStatusCode(response.statusCode)))
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let todoItemNet = try jsonDecoder.decode(NetworkingModel.self, from: data)
                    let todoItem = try ToDoItem(with: todoItemNet)
                    complete(.success(todoItem))
                } catch {
                    complete(.failure(.deserializationError(error)))
                }
            }
            task.resume()
        }
    }
    
    func deleteItem(at id: String, completion: @escaping (Result<ToDoItem, NetworkingServiceError>) -> Void) {
        
    }
    
    func updateItem(item: ToDoItem, completion: @escaping (Result<ToDoItem, NetworkingServiceError>) -> Void) {
        
    }
}
