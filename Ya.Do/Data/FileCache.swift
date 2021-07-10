//
//  FileCache.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import Foundation
import DevToDoPod

protocol FileCacheProtocol {
    func addItem(_ item: ToDoItem)
    func removeItem(at id: String)
    func saveAllItems(to file: String)
    func getAllItems(from file: String)
}

final class FileCache: FileCacheProtocol {
    private let netManager = NetworkManager()
    private(set) var tasks = [ToDoItem]()
    private(set) var completedTasks = [ToDoItem]()
    // MARK: - FILTER TASKS
    func returnCompleted() {
        completedTasks = tasks.filter { $0.isCompleted == false}
    }
    // MARK: - METHOD ADD TASK
    func addItem(_ item: ToDoItem) {
        tasks.append(item)
        serverUploadItem(item: item)
    }
    func updateItem(index: Int, item: ToDoItem) {
        tasks[index] = item
        serverUpdateItem(item: item)
    }
    func updateFilterItem(index: Int, item: ToDoItem) {
        completedTasks[index] = item
    }
    // MARK: - METHOD REMOVE TASK
    func removeItem(at id: String) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks.remove(at: index)
        deleteItem(at: id)
    }
    // MARK: - METHOD SAVE ALL TASKS
    func saveAllItems(to file: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let tasksDict = self?.tasks.map { $0.json }
            guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let fileUrl = path.appendingPathComponent(file)
            do {
                let data = try JSONSerialization.data(withJSONObject: tasksDict as Any, options: [])
                try data.write(to: fileUrl, options: [])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    // MARK: - METHOD GET ALL TASKS
    func getAllItems(from file: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let fileUrl = path.appendingPathComponent(file)
            do {
                let data = try Data(contentsOf: fileUrl)
                guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { return }
               // DispatchQueue.main.async {
                self?.tasks = jsonDict.compactMap { ToDoItem.parse(json: $0)}
                self?.merge()
              //  }
            } catch {
                    print(error.localizedDescription)
            }
        }
    }

    func merge() {
        netManager.fetchItems { [weak self] (result) in
            switch result {
            case .success(let items):
                self?.tasks.append(contentsOf: items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func serverUploadItem(item: ToDoItem ) {
        netManager.uploadItem(item: item)
    }

    func serverUpdateItem(item: ToDoItem) {
        netManager.updateItem(item: item)
    }
    func deleteItem(at id: String) {
        netManager.deleteItem(at: id)
    }
}
