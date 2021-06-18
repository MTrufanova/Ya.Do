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
    let date: Date?

    init(id: String = UUID().uuidString, text: String, priority: Priority, date: Date?) {
        self.id = id
        self.text = text
        self.priority = priority
        self.date = date
    }
}

enum Priority: String {
    case high
    case low
    case normal
}

extension ToDoItem {
    struct Keys {
        static let id = "id"
        static let text = "text"
        static let priority = "priority"
        static let date = "timestamp"
    }
    static func parse(json: Any) -> ToDoItem? {
        guard let data = json as? [String: Any],
              let id = data[Keys.id] as? String,
              let text = data[Keys.text] as? String,
              let priorityStr = data[Keys.priority] as? String,
              let priority = Priority(rawValue: priorityStr) else { return nil}
        var date: Date?
        if let timestamp = data[Keys.date] as? TimeInterval {
            date = Date(timeIntervalSince1970: timestamp)
        }
        return ToDoItem(id: id, text: text, priority: priority, date: date)
    }

    var json: Any {
        var params: [String: Any] = [:]
        params[Keys.id] = id
        params[Keys.text] = text
        params[Keys.date] = date?.timeIntervalSince1970
        if priority != .normal {
            params[Keys.priority] = priority.rawValue
        }
        return params
    }
}
