//
//  TodoItem+CoreDataProperties.swift
//  Ya.Do
//
//  Created by msc on 24.07.2021.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var id: String
    @NSManaged public var text: String
    @NSManaged public var priority: String?
    @NSManaged public var deadline: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Int64
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isDirty: Bool

}

extension TodoItem {
    var importance: ToDoItem.Priority {

        get {
            guard let prior = priority else {
                return .basic
            }
            return ToDoItem.Priority(rawValue: prior) ?? .basic }

         set { self.priority = newValue.rawValue }

       }
}
