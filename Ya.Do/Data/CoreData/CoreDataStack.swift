//
//  CoreDataStack.swift
//  Ya.Do
//
//  Created by msc on 10.07.2021.
//

import Foundation
import DevToDoPod
import CoreData

protocol CoreDataStackProtocol {
    func addItem(item: TodoItem, completion: @escaping (Result<TodoItem, Error>) -> Void)
    func fetchItems(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func deleteItem(item: TodoItem)
    func updateItem(item: TodoItem)
    func turnCompleted(item: TodoItem)
}

final class CoreDataStack: CoreDataStackProtocol {
  
   private let queue = DispatchQueue.global(qos: .utility)

   private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Ya.Do")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    private lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()

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
    func addItem(item: TodoItem, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TodoItem", in: context) else { return }
        do {
        let itemObject = TodoItem(entity: entity, insertInto: context)
        itemObject.id = item.id
        itemObject.isCompleted = item.isCompleted
        itemObject.text = item.text
        itemObject.importance = item.importance
        itemObject.deadline = item.deadline
        itemObject.createdAt = item.createdAt
        itemObject.updatedAt = item.updatedAt
        itemObject.isDirty = item.isDirty

            try context.save()
            completion(.success(itemObject))
        } catch let error {
            completion(.failure(error))
        }
    }

    func fetchItems(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()

        do {
            let dataTasks = try context.fetch(fetchRequest)
             completion(.success(dataTasks))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deleteItem(item: TodoItem) {
        queue.async { [weak self] in
            self?.context.delete(item)

            do {
                try self?.context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }

    }

    func updateItem(item: TodoItem) {

        guard let coreItem = getCoreItem(byIdentifier: item.id) else { return }
        coreItem.text = item.text
        coreItem.deadline = item.deadline
        coreItem.importance = item.importance
        coreItem.updatedAt = Date()

        queue.async { [weak self] in
            do {
                try self?.context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }

    }

    func turnCompleted(item: TodoItem) {
        guard let coreItem = getCoreItem(byIdentifier: item.id) else {return}

        coreItem.isCompleted = !item.isCompleted

        queue.async { [weak self] in
            do {
                try self?.context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }

    }

    private func getCoreItem(byIdentifier id: UUID) -> TodoItem? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        fetchRequest.predicate = NSPredicate(format: "id==%@", id as CVarArg)
        guard let items = try? context.fetch(fetchRequest) as? [TodoItem] else { return nil}
            guard let item = items.first(where: { $0.id == id }) else {
                return nil
            }
            return item
    }
}
