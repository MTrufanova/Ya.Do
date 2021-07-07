//
//  NetworkService.swift
//  Ya.Do
//
//  Created by msc on 27.06.2021.
//

import Foundation
import DevToDoPod

enum APIError: Error {
    case noData
}

protocol NetworkServiceProtocol {
    func getTasks(completion: @escaping (Result<[NetworkingModel], Error>) -> Void)
    func postItem(item: NetworkingModel)
   // func putTasks(onResult: @escaping (Result<[NetworkingModel], Error>) -> Void)
    func deleteItem(at id: String, onResult: @escaping (Result<NetworkingModel, Error>) -> Void)
    func updateItem(item: NetworkingModel, onResult: @escaping (Result<NetworkingModel, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 30.0
        return session
    }()

    let token = "LTI1NDg1ODAxMTQ3MjQ1NzgxMDY"
    // MARK: - GET
    func getTasks(completion: @escaping (Result<[NetworkingModel], Error>) -> Void) {

        guard let url =  Endpoint.getTasks.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"

        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in

            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Response is empty")
                return
            }

            print(response.statusCode)

            guard let data = data else {
                print("Data is empty")
                return
            }

            do {
                let jsonData = try JSONDecoder().decode([NetworkingModel].self, from: data)

                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    // MARK: - POST
   // func postItem(item: NetworkingModel, completion: @escaping (Result<NetworkingModel, Error>) -> Void) {
    func postItem(item: NetworkingModel) {

        guard let url =  Endpoint.postTask.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        guard let uploadData = try? JSONEncoder().encode(item) else {
            return }
        let task = session.uploadTask(with: urlRequest, from: uploadData) { (data, _, error) in

            if let error = error {
               // completion(.failure(error))
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let taskResponse = try JSONDecoder().decode(NetworkingModel.self, from: data)
               // completion(.success(taskResponse))
            } catch let error {
                print(error)
               // completion(.failure(error))
            }
        }
        task.resume()
    }
    // MARK: - UPDATE ITEMS
   /* func putTasks(onResult: @escaping (Result<[NetworkingModel], Error>) -> Void) {
        guard let url =  Endpoint.putTasks.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
    }*/
    // MARK: - UPDATE ITEM
    func updateItem(item: NetworkingModel, onResult: @escaping (Result<NetworkingModel, Error>) -> Void) {
        guard let url = Endpoint.updateItem(id: item.id).url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        guard let data = try? JSONEncoder().encode(item) else { return }
        urlRequest.httpBody = data
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            guard let data = data else {
                onResult(.failure(APIError.noData))
                return
            }
            do {
                let taskResponse = try JSONDecoder().decode(NetworkingModel.self, from: data)
                onResult(.success(taskResponse))
            } catch let error {
                print(error)
                onResult(.failure(error))
            }
        }
        task.resume()

    }
    // MARK: - DELETE
    func deleteItem(at id: String, onResult: @escaping (Result<NetworkingModel, Error>) -> Void) {
        guard let url =  Endpoint.removeItem(id: id).url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            guard let data = data else {
                onResult(.failure(APIError.noData))
                return
            }
            do {
                let taskResponse = try JSONDecoder().decode(NetworkingModel.self, from: data)
                onResult(.success(taskResponse))
            } catch let error {
                print(error)
                onResult(.failure(error))
            }
        }
        task.resume()
    }
}
