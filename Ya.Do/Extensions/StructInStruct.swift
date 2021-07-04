//
//  StructInStruct.swift
//  Ya.Do
//
//  Created by msc on 04.07.2021.
//

import Foundation
import DevToDoPod

func intoNetworkModel(from item: ToDoItem) -> NetworkingModel {
    guard let date = item.deadline?.timeIntervalSince1970 else {
        return NetworkingModel(id: item.id,
                               text: item.text,
                               importance: item.priority.rawValue,
                               done: item.isCompleted,
                               deadline: nil,
                               createdAt: item.createdAt,
                               updatedAt: item.updatedAt)
    }
    
    return NetworkingModel(id: item.id,
                           text: item.text,
                           importance: item.priority.rawValue,
                           done: item.isCompleted,
                           deadline: Int(date),
                           createdAt: item.createdAt,
                           updatedAt: item.updatedAt)
}

func intoToDoItem(from array: [NetworkingModel]) -> [ToDoItem] {
    let taskModel = array.map { (model) -> ToDoItem in
        guard let date = model.deadline else { return ToDoItem(id: model.id,
                                                               text: model.text,
                                                               priority: ToDoItem.Priority(rawValue: model.importance) ?? .basic,
                                                               deadline: nil,
                                                               isCompleted: model.done,
                                                               createdAt: model.createdAt,
                                                               updatedAt: model.updatedAt,
                                                               isDirty: false)}
        return ToDoItem(id: model.id,
                        text: model.text,
                        priority: ToDoItem.Priority(rawValue: model.importance) ?? .basic,
                        deadline: Date(timeIntervalSince1970: Double(date)),
                        isCompleted: model.done,
                        createdAt: model.createdAt,
                        updatedAt: model.updatedAt,
                        isDirty: false)
        
    }
    return taskModel
}
