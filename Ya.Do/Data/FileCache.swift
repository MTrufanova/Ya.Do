//
//  FileCache.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import Foundation

protocol FileCacheProtocol {
    func addItem(_ item: ToDoItem)
    func removeItem(at id: String)
    func saveAllItems(to file: String)
    func getAllItems(from file: String)
}

class FileCache: FileCacheProtocol {
    private(set) var tasks = [ToDoItem]()
    // MARK: - METHOD ADD TASK
    /*  потенциальная проблема: может возникнуть дубль. Можно добавить структуру с другими данными, но с таким же айдишником и это никак не проверяется, а потом в методе removeTask может удалится не та структура, которую мы ожидали*/
    func addItem(_ item: ToDoItem) {
        tasks.append(item)
    }
    // MARK: - METHOD REMOVE TASK
    func removeItem(at id: String) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks.remove(at: index)
    }
    // MARK: - METHOD SAVE ALL TASKS
    // throws доделать обработку ошибок
    func saveAllItems(to file: String) {
        let tasksDict = tasks.map { $0.json }
        // get file's url
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = path.appendingPathComponent(file)
        print(path)
        // save array in data
        do {
            let data = try JSONSerialization.data(withJSONObject: tasksDict, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error.localizedDescription)
        }
    }
    // MARK: - METHOD GET ALL TASKS
    func getAllItems(from file: String) {
        // get file's url
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = path.appendingPathComponent(file)
        // data from json's file in array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }
            if let task = ToDoItem.parse(json: jsonDict) {
                tasks.append(task)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
