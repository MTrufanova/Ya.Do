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
    var data: [TodoItem]? {get set}
    func loadItems()
}

class AllTasksPresenter: AllTasksPresenterProtocol {
    weak var view: AllTasksProtocol?
    let localData: CoreDataStackProtocol
    var data: [TodoItem]?
    
    required init(view: AllTasksProtocol, localData: CoreDataStackProtocol) {
        self.view = view
        self.localData = localData
        loadItems()
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
    
}
