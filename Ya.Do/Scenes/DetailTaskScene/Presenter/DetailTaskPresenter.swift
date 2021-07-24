//
//  DetailTaskPresenter.swift
//  Ya.Do
//
//  Created by msc on 18.07.2021.
//

import Foundation

protocol DetailTaskProtocol: class {
    func setTask(task: ToDoItem?)
}

protocol DetailTaskPresenterProtocol: class {
    init(view: DetailTaskProtocol, localData: CoreDataStackProtocol, task: ToDoItem?, delegate: DetailTaskViewControllerDelegate?)
    func setTask()
    func createItem(text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?) -> ToDoItem?
    func itemToUpdate(id: String, text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?) -> ToDoItem?
    func addItem(item: ToDoItem)
    func removeItem(item: ToDoItem)
}

class DetailTaskPresenter: DetailTaskPresenterProtocol {
    weak var view: DetailTaskProtocol?
    weak var delegate: DetailTaskViewControllerDelegate?
    let localData: CoreDataStackProtocol!
    var task: ToDoItem?

    required init(view: DetailTaskProtocol, localData: CoreDataStackProtocol, task: ToDoItem?, delegate: DetailTaskViewControllerDelegate?) {
        self.view = view
        self.localData = localData
        self.task = task
        self.delegate = delegate
    }

   public func setTask() {
    self.view?.setTask(task: task)
    }

    func createItem(text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?) -> ToDoItem? {

        return ToDoItem(text: text, priority: priority, deadline: deadline, createdAt: createdAt, updatedAt: updatedAt)
    }
    func itemToUpdate(id: String, text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?) -> ToDoItem? {

        return ToDoItem(id: id, text: text, priority: priority, deadline: deadline, createdAt: createdAt, updatedAt: updatedAt)
    }

    func addItem(item: ToDoItem) {
        delegate?.addItem(item: item)
    }

    func removeItem(item: ToDoItem) {
        delegate?.removeItem(item: item)
    }

}
