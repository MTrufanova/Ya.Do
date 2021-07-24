//
//  NetworkingModel.swift
//  Ya.Do
//
//  Created by msc on 01.07.2021.
//

import Foundation

struct NetworkingModel: Codable {
    let id: String
    let text: String
    let importance: String
    let done: Bool
    let deadline: Int64?
    let createdAt: Int64
    let updatedAt: Int64?

    enum CodingKeys: String, CodingKey {
        case id, text, importance, done, deadline
        case createdAt = "created_at"
        case updatedAt = "updated_at"

    }
}
