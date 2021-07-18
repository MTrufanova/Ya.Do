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
    
}
