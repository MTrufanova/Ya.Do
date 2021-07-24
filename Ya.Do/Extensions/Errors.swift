//
//  StructInStruct.swift
//  Ya.Do
//
//  Created by msc on 04.07.2021.
//

import Foundation

enum NetworkingServiceError: Error {

    case failedToCreateUrl
    case networkingError(Error)
    case noResponseOrData
    case deserializationError(Error)
    case serializationError(Error)
    case invalidStatusCode(Int)
    case forcedFailure
}

enum TodoItemError: Error {
    case failedToCreateImportance(String)
}
