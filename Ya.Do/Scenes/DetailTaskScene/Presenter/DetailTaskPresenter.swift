//
//  DetailTaskPresenter.swift
//  Ya.Do
//
//  Created by msc on 18.07.2021.
// swiftlint:disable function_parameter_count

import Foundation

protocol DetailTaskViewProtocol: AnyObject {
    func setTask(task: ToDoItem?)
}

protocol DetailTaskPresenterDelegate: AnyObject {
    func addItem(item: ToDoItem)
    func removeItem(item: ToDoItem)
}

protocol DetailTaskPresenterProtocol: AnyObject {

    func setTask()
    func createItem(text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?) -> ToDoItem?
    func itemToUpdate(id: String,
                      text: String,
                      priority: ToDoItem.Priority,
                      deadline: Date?,
                      createdAt: Int64,
                      updatedAt: Date?) -> ToDoItem?
    func addItem(item: ToDoItem)
    func removeItem(item: ToDoItem)
}

class DetailTaskPresenter: DetailTaskPresenterProtocol {
    weak var view: DetailTaskViewProtocol?
    weak var delegate: DetailTaskPresenterDelegate?
    let localData: CoreDataStackProtocol
    var task: ToDoItem?

    required init(view: DetailTaskViewProtocol, localData: CoreDataStackProtocol, task: ToDoItem?, delegate: DetailTaskPresenterDelegate?) {
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
    func itemToUpdate(id: String,
                      text: String,
                      priority: ToDoItem.Priority,
                      deadline: Date?,
                      createdAt: Int64,
                      updatedAt: Date?) -> ToDoItem? {

        return ToDoItem(id: id, text: text, priority: priority, deadline: deadline, createdAt: createdAt, updatedAt: updatedAt)
    }

    func addItem(item: ToDoItem) {
        delegate?.addItem(item: item)
    }

    func removeItem(item: ToDoItem) {
        delegate?.removeItem(item: item)
    }

}
