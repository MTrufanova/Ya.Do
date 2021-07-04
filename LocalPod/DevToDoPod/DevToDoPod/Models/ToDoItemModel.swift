//
//  ToDoItemModel.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import Foundation

public struct ToDoItem {
    public let id: String
    public let text: String
    public let priority: Priority
    public let deadline: Date?
    public var isCompleted: Bool
    public let createdAt: Int
    public let updatedAt: Int?
    public let isDirty: Bool
    
    public init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date?, isCompleted: Bool = false, createdAt: Int, updatedAt: Int?, isDirty: Bool = false) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isDirty = isDirty
    }
    public enum Priority: String {
        case important
        case low
        case basic
    }
}

