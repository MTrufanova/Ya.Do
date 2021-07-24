//
//  AllTasksPresenter.swift
//  Ya.Do
//
//  Created by msc on 18.07.2021.
//

import Foundation

protocol AllTasksProtocol: class {
    func succes()
    func failure(error: Error)
    func setNumOfDoneItems(counterText: String)
}

protocol AllTasksPresenterProtocol: class {
    init(view: AllTasksProtocol, manager: DataManagerProtocol)
    var data: [ToDoItem] { get }
    var filterData: [ToDoItem] { get }
    func loadItems()
    func returnUncompleted()
    func turnCompleted(item: ToDoItem)
    func deleteItem(item: ToDoItem)
    func updateItem(item: ToDoItem)
    func addItem(item: ToDoItem)
    func countDoneItems() -> String
}

class AllTasksPresenter: AllTasksPresenterProtocol {
    weak var view: AllTasksProtocol?
    let manager: DataManagerProtocol
    private(set) var data = [ToDoItem]()
    private(set) var filterData = [ToDoItem]()
    private let queue = DispatchQueue(label: "ItemPresenter", attributes: .concurrent)

    required init(view: AllTasksProtocol, manager: DataManagerProtocol) {
        self.view = view
        self.manager = manager
    }

    func loadItems() {
        manager.loadData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let items):
                self.data = items
                self.view?.succes()
                self.view?.setNumOfDoneItems(counterText: self.countDoneItems())
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }

    }

    func returnUncompleted() {
        filterData = data.filter { $0.isCompleted == false}
    }
    func countDoneItems() -> String {
        let count = self.data.filter { $0.isCompleted == true }.count
        return Title.done + "\(count)"

    }

    func turnCompleted(item: ToDoItem) {
        var newItem = item
        newItem.isCompleted = !item.isCompleted
        newItem.updatedAt = Date()
        manager.turnCompleted(item: newItem)
        guard let index = self.data.firstIndex(where: { $0.id == item.id }) else { return }
        self.data[index] = newItem
        self.view?.succes()
    }

    func deleteItem(item: ToDoItem) {
        manager.deleteItem(item: item)
        guard let index = data.firstIndex(where: { $0.id == item.id }) else { return }
        data.remove(at: index)
    }

    func updateItem(item: ToDoItem) {
        manager.updateItem(item: item)
        guard let index = data.firstIndex(where: { $0.id == item.id }) else { return }
        data[index] = item
    }

    func addItem(item: ToDoItem) {
        manager.addItem(item: item)
        data.append(item)
    }
}
