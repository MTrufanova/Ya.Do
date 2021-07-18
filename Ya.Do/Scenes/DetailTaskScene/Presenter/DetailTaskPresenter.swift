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
    init(view: DetailTaskProtocol, localData: CoreDataStackProtocol, task: TodoItem?)
    func setTask()
    func createItem(text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?)
}

class DetailTaskPresenter: DetailTaskPresenterProtocol {
    weak var view: DetailTaskProtocol?
    let localData: CoreDataStackProtocol!
    var task: TodoItem?

    required init(view: DetailTaskProtocol, localData: CoreDataStackProtocol, task: TodoItem?) {
        self.view = view
        self.localData = localData
        self.task = task
    }

   public func setTask() {
    self.view?.setTask(task: task)
    }

    func createItem(text: String, priority: ToDoItem.Priority, deadline: Date?, createdAt: Int64, updatedAt: Date?) {
        localData.createItem(text: text, priority: priority, deadline: deadline, createdAt: createdAt, updatedAt: updatedAt)
    }

}
