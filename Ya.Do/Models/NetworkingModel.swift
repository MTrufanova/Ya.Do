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
    let deadline: Int?
    let createdAt: Int
    let updatedAt: Int?

    enum CodingKeys: String, CodingKey {
        case id, text, importance, done, deadline
        case createdAt = "created_at"
        case updatedAt = "updated_at"

    }
}
