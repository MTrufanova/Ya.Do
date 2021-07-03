//
//  APIClient.swift
//  Ya.Do
//
//  Created by msc on 27.06.2021.
//

import Foundation

protocol APIClient {
    func fetchData(onResult: @escaping (Result<[ToDoItem], Error>) -> Void)
    
}

class APIClientclass: APIClient {
    func fetchData(onResult: @escaping (Result<[ToDoItem], Error>) -> Void) {
        
    }
}
