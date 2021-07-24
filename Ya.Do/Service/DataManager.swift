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
    private let netService = NetworkService()
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
            self.getServerData { (result) in
                switch result {
                case .success(let items):
                    completion(.success(items))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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

    func getServerData( completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        netService.getTasks { [weak self] (result) in
            switch result {
            case .success(let items):
                self?.networkItems = items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func turnCompleted(item: ToDoItem) {
        localService.turnCompleted(item: item)
        updateServerItem(item: item)
    }

    func updateItem(item: ToDoItem) {
        localService.updateItem(item: item)
        updateServerItem(item: item)
    }
    func deleteItem(item: ToDoItem) {
        localService.deleteItem(item: item)
        deleteServerItem(item: item)
    }

    func addItem(item: ToDoItem) {
        addLocalItem(item: item, addToArray: false)
        addServerItem(item: item)
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

    // MARK: - Methods for Server
    func addServerItem(item: ToDoItem) {
        netService.postItem(item: item) { (result) in
            switch result {
            case .success(_):
                print("Ok")
            case .failure(let error):
                print("Failure put item", error)
            }
        }
    }

    func updateServerItem(item: ToDoItem) {
        netService.updateItem(item: item) { (result) in
            switch result {
            case .success(_):
                print("ok")
            case .failure(let error):
                print("Failure updating item", error)
            }
        }
    }

    func deleteServerItem(item: ToDoItem) {
        netService.deleteItem(at: item.id) { (result) in
            switch result {
            case .success(_):
                print("ok")
            case .failure(let error):
                print("Failure deleting item", error)
            }
        }
    }

}
