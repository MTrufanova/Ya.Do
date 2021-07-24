//
//  DataManager.swift
//  Ya.Do
//
//  Created by msc on 07.07.2021.
//

import Foundation

protocol DataManagerProtocol {
    func loadData(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func updateItem(item: ToDoItem)
    func deleteItem(item: ToDoItem)
    func addItem(item: ToDoItem)
    func turnCompleted(item: ToDoItem)
}

class DataManager: DataManagerProtocol {

    private let localService = CoreDataStack()
    private let lockNS = NSRecursiveLock()
    private(set) var data: [ToDoItem] = []
    var networkItems = [ToDoItem]()
    var localData = [ToDoItem]()
    var localItemsDict: [String: ToDoItem] = [:]

    // MARK: - Methods for load data
    func loadData(completion: @escaping (Result<[ToDoItem], Error>) -> Void ) {

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.getLocalData()

        }
    }

    func getLocalData() {
        localService.fetchItems { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let items):
                self.localData = items
            case .failure(let error):
                print(error)
            }
        }
    }



    func turnCompleted(item: ToDoItem) {
        localService.turnCompleted(item: item)

    }

    func updateItem(item: ToDoItem) {
        localService.updateItem(item: item)
    }
    func deleteItem(item: ToDoItem) {
        localService.deleteItem(item: item)

    }

    func addItem(item: ToDoItem) {
        addLocalItem(item: item, addToArray: false)

    }

    // MARK: - Method add  for Local data
    func addLocalItem(item: ToDoItem, addToArray: Bool) {

        localService.addItem(item: item) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let item):
                guard addToArray == true else {
                    print("ok")
                    break
                }
                self.data.append(item)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}



