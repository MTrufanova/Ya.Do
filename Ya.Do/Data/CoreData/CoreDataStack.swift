//
//  CoreDataStack.swift
//  Ya.Do
//
//  Created by msc on 10.07.2021.
//

import Foundation
import DevToDoPod
import CoreData

class CoreDataStack {
    var data = [TodoItem]()
    var filterData = [TodoItem]()
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Ya.Do")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func returnUncompleted() {
        filterData = data.filter { $0.isCompleted == false}
    }
    func createItem(text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?) -> TodoItem? {

        guard let entity = NSEntityDescription.entity(forEntityName: "TodoItem", in: backgroundContext) else {
            return nil }
        let itemObject = TodoItem(entity: entity, insertInto: backgroundContext)
        itemObject.id = UUID()
        itemObject.isCompleted = false
        itemObject.text = text
        itemObject.importance = priority
        itemObject.deadline = deadline
        itemObject.createdAt = createdAt
        itemObject.updatedAt = updatedAt
        itemObject.isDirty = false
        return itemObject
    }
    func addItem(item: TodoItem) {
       guard let entity = NSEntityDescription.entity(forEntityName: "TodoItem", in: context) else { return }

       // let itemObject = TodoItem(entity: entity, insertInto: backgroundContext)
       // itemObject.text = text

        let itemObject = TodoItem(entity: entity, insertInto: backgroundContext)
        itemObject.id = item.id
        itemObject.isCompleted = item.isCompleted
        itemObject.text = item.text
        itemObject.importance = item.importance
        itemObject.deadline = item.deadline
        itemObject.createdAt = item.createdAt
        itemObject.updatedAt = item.updatedAt
        itemObject.isDirty = item.isDirty
        do {
            data.append(item)
            try backgroundContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func fetchItems() {
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()

        do {
            data = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func deleteItem(item: TodoItem) {
        guard let index = data.firstIndex(where: { $0.id == item.id }) else { return }
        data.remove(at: index)
        context.delete(item)

        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }


}
