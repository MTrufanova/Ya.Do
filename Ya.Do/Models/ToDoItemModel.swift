//
//  ToDoItemModel.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import Foundation

struct ToDoItem {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    var isCompleted: Bool
    
    init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date?, isCompleted: Bool = false) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isCompleted = isCompleted
    }
    enum Priority: String {
        case high
        case low
        case normal
    }
}

extension ToDoItem {
    private struct Keys {
        static let id = "id"
        static let text = "text"
        static let priority = "priority"
        static let deadline = "timestamp"
        static let isComleted = "isComleted"
    }
    static func parse(json: Any) -> ToDoItem? {
        guard let data = json as? [String: Any],
              let id = data[Keys.id] as? String,
              let text = data[Keys.text] as? String,
              let isComleted = data[Keys.isComleted] as? Bool else { return nil }
        let priority = (data[Keys.priority] as? String).flatMap(Priority.init(rawValue:)) ?? .normal
        var deadline: Date?
        if let timestamp = data[Keys.deadline] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: timestamp)
        }
        return ToDoItem(id: id, text: text, priority: priority, deadline: deadline, isCompleted: isComleted)
    }
    
    var json: Any {
        var params: [String: Any] = [:]
        params[Keys.id] = id
        params[Keys.text] = text
        params[Keys.deadline] = deadline?.timeIntervalSince1970
        params[Keys.isComleted] = isCompleted
        if priority != .normal {
            params[Keys.priority] = priority.rawValue
        }
        return params
    }
}
