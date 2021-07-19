//
//  DetailTaskPresenter.swift
//  Ya.Do
//
//  Created by msc on 18.07.2021.
//

import Foundation
import DevToDoPod

protocol DetailTaskProtocol: class {
    func setTask(task: TodoItem?)
}

protocol DetailTaskPresenterProtocol: class {
    init(view: DetailTaskProtocol, localData: CoreDataStackProtocol, task: TodoItem?, delegate: DetailTaskViewControllerDelegate?)
    func setTask()
    func createItem(text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?) -> TodoItem?
    func addItem(item: TodoItem)
    func removeItem(item: TodoItem)
}

class DetailTaskPresenter: DetailTaskPresenterProtocol {
    weak var view: DetailTaskProtocol?
    weak var delegate: DetailTaskViewControllerDelegate?
    let localData: CoreDataStackProtocol!
    var task: TodoItem?

    required init(view: DetailTaskProtocol, localData: CoreDataStackProtocol, task: TodoItem?, delegate: DetailTaskViewControllerDelegate?) {
        self.view = view
        self.localData = localData
        self.task = task
        self.delegate = delegate
    }

   public func setTask() {
    self.view?.setTask(task: task)
    }

    func createItem(text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?) -> TodoItem? {
        localData.createItem(text: text, priority: priority, deadline: deadline, createdAt: createdAt, updatedAt: updatedAt)
    }

    func addItem(item: TodoItem) {
        delegate?.addItem(item: item)
    }

    func removeItem(item: TodoItem)  {
        delegate?.removeItem(item: item)
    }
}
