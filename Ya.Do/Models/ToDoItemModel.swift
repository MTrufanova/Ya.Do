//
//  ToDoItemModel.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import Foundation
import DevToDoPod

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
        let priority = (data[Keys.priority] as? String).flatMap(Priority.init(rawValue:)) ?? .basic
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
        if priority != .basic {
            params[Keys.priority] = priority.rawValue
        }
        return params
    }
}
