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
}

protocol AllTasksPresenterProtocol: class {
    init(view: AllTasksProtocol, localData: CoreDataStackProtocol)
    var data: [TodoItem] { get }
    var filterData: [TodoItem] { get }
    func loadItems()
    func returnUncompleted()
    func turnCompleted(item: TodoItem)
    func deleteItem(item: TodoItem)
    func updateItem(item: TodoItem)
    func addItem(item: TodoItem)
}

class AllTasksPresenter: AllTasksPresenterProtocol {
    weak var view: AllTasksProtocol?
    let localData: CoreDataStackProtocol
    private(set) var data = [TodoItem]()
    private(set) var filterData = [TodoItem]()
    
    required init(view: AllTasksProtocol, localData: CoreDataStackProtocol) {
        self.view = view
        self.localData = localData
    }
    
    func loadItems() {
        localData.fetchItems { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.data = items
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }

   func returnUncompleted() {
        filterData = data.filter { $0.isCompleted == false}
    }

    func turnCompleted(item: TodoItem) {
        localData.turnCompleted(item: item)
    }

    func deleteItem(item: TodoItem) {
        guard let index = data.firstIndex(where: { $0.id == item.id }) else { return }
        data.remove(at: index)
        localData.deleteItem(item: item)
    }

    func updateItem(item: TodoItem) {
        localData.updateItem(item: item)
    }

    func addItem(item: TodoItem) {

        localData.addItem(item: item) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let item):
                self.data.append(item)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
