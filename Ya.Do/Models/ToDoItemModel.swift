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
    public let createdAt: Int64
    public var updatedAt: Date?
    public let isDirty: Bool

    public init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date?, isCompleted: Bool = false, createdAt: Int64, updatedAt: Date?, isDirty: Bool = false) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isDirty = isDirty
    }
    public enum Priority: String, Codable {
        case important
        case low
        case basic
    }
}

extension ToDoItem {
    var asNetModel: NetworkingModel {

        return NetworkingModel(id: id,
                               text: text,
                               importance: priority.rawValue,
                               done: isCompleted,
                               deadline: (deadline?.timeIntervalSince1970).map(Int64.init),
                               createdAt: createdAt,
                               updatedAt: (updatedAt?.timeIntervalSince1970).map(Int64.init)
        )
    }

    init(with netModel: NetworkingModel) throws {
        guard let priority = Priority(rawValue: netModel.importance) else {
            throw TodoItemError.failedToCreateImportance(netModel.importance)
        }

        self.id = netModel.id
        self.text = netModel.text
        self.priority = priority
        self.isCompleted = netModel.done

        if let deadlineTimestamp = netModel.deadline {
            self.deadline = Date(timeIntervalSince1970: Double(deadlineTimestamp))
        } else {
            self.deadline = nil
        }

        if let updateDate = netModel.updatedAt {
            self.updatedAt = Date(timeIntervalSince1970: Double(updateDate))
        } else {
            self.updatedAt = nil
        }

        self.createdAt = netModel.createdAt
        self.isDirty = false
    }

    init(withLocal localModel: TodoItem) throws {

        self.id = localModel.id
        self.text = localModel.text
        self.priority = localModel.importance
        self.isCompleted = localModel.isCompleted
        self.deadline = localModel.deadline
        self.createdAt = localModel.createdAt
        self.updatedAt = localModel.updatedAt
        self.isDirty = localModel.isDirty
    }
}
