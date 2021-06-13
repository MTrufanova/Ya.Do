//
//  FileCache.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import Foundation

protocol FileCacheProtocol {
    func addTask(_ item: ToDoItem)
    func removeTask(at id: String)
    func saveAllTasks(at file: String)
    func getAllTasks(from file: String)
}

class FileCache: FileCacheProtocol {
   private(set) var tasks = [ToDoItem]()

    // MARK: - METHOD ADD TASK
    func addTask(_ item: ToDoItem) {
        tasks.append(item)
    }
    // MARK: - METHOD REMOVE TASK
    func removeTask(at id: String) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks.remove(at: index)
    }
    // MARK: - METHOD SAVE ALL TASKS
    func saveAllTasks(at file: String) {
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
    func getAllTasks(from file: String) {
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
