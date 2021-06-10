//
//  ToDoItemModel.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import Foundation

struct ToDoItem {
    let taskId: String?
    let text: String
    let priority: Priority?
    let date: String?

    init(taskId: String?, text: String, priority: Priority?, date: String?) {
        self.taskId = taskId ?? UUID().uuidString
        self.text = text
        self.priority = priority
        self.date = date
    }
}

enum Priority {
    case high
    case low
    case normal
}

extension ToDoItem {
    //должен возвращать ToDoItem?
    static func parse(json: Any) -> [ToDoItem]? {
       //  выход из сериализации
        var tasksItem = [ToDoItem]()
        guard let data = json as? [String: Any] else { return nil}
        guard let tasks = data["task"] as? [[String: Any]] else { return nil }
        
        for item in tasks {
            var id: String?
            var taskText: String?
            var priority: Priority?
            var date: String?
            
            if let ids = item["taskId"] as? String {
                id = ids
            }
            if let text = item["taskText"] as? String {
                taskText = text
            }
            if let taskPriority = item["priority"] as? Priority {
                priority = taskPriority
            }
            if let dateTask = item["timestamp"] as? String {
                date = dateTask
            }
            tasksItem.append(ToDoItem(taskId: id, text: taskText ?? "", priority: priority, date: date))
        }
        
        
        return tasksItem
        
        
    }
    var json: Any {
        if priority == Priority.normal {
            return ["task": ["taskId": taskId ?? "", "taskText": text, "priority": nil, "timestamp": date]]
        } else {
            return ["task": ["taskId": taskId ?? "", "taskText": text, "priority": priority ?? Priority.normal, "timestamp": date ?? " "]]
        }
       
    }
}
/*Содержит вычислимое свойство (var json: Any) для формирование json'а 〉Не сохранять в json важность, если она "обычная"
 〉Не сохранять в json сложные объекты (Date)
 〉Сохранять deadline только если он задан
 〉Обязательно использовать JSONSerialization (т.е. работу со словарем)*/
