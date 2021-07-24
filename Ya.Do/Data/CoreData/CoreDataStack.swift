//
//  CoreDataStack.swift
//  Ya.Do
//
//  Created by msc on 10.07.2021.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    func addItem(item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func fetchItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func deleteItem(item: ToDoItem)
    func updateItem(item: ToDoItem)
    func turnCompleted(item: ToDoItem)
}

final class CoreDataStack: CoreDataStackProtocol {

    private let queue = DispatchQueue.global(qos: .utility)

    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "TodoItem")
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

    func addItem(item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TodoItem", in: context) else { return }
        do {
            let itemObject = TodoItem(entity: entity, insertInto: context)
            itemObject.id = item.id
            itemObject.isCompleted = item.isCompleted
            itemObject.text = item.text
            itemObject.importance = item.priority
            itemObject.deadline = item.deadline
            itemObject.createdAt = item.createdAt
            itemObject.updatedAt = item.updatedAt
            itemObject.isDirty = item.isDirty

            try context.save()
            let todoItem = try ToDoItem.init(withLocal: itemObject)
            completion(.success(todoItem))
        } catch let error {
            completion(.failure(error))
        }
    }

    func fetchItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        do {
            let dataTasks = try self.context.fetch(fetchRequest)
            let todoItems = try dataTasks.map { try ToDoItem.init(withLocal: $0) }
            completion(.success(todoItems))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deleteItem(item: ToDoItem) {
        guard let coreItem = getCoreItem(byIdentifier: item.id) else { return }
        queue.async { [weak self] in
            self?.context.delete(coreItem)
            do {
                try self?.context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }

    }

    func updateItem(item: ToDoItem) {
        guard let coreItem = getCoreItem(byIdentifier: item.id) else { return }
        coreItem.text = item.text
        coreItem.deadline = item.deadline
        coreItem.importance = item.priority
        coreItem.updatedAt = Date()

        queue.async { [weak self] in
            do {
                try self?.context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func turnCompleted(item: ToDoItem) {
        guard let coreItem = getCoreItem(byIdentifier: item.id) else {return}

        coreItem.isCompleted = item.isCompleted
        coreItem.updatedAt = item.updatedAt

        queue.async { [weak self] in
            do {
                try self?.context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }

    }

    private func getCoreItem(byIdentifier id: String) -> TodoItem? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        fetchRequest.predicate = NSPredicate(format: "id==%@", id as CVarArg)
        guard let items = try? context.fetch(fetchRequest) as? [TodoItem] else { return nil}
        guard let item = items.first(where: { $0.id == id }) else {
            return nil
        }
        return item
    }
}
