//
//  FileCache.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import Foundation

class FileCache {
   private var tasks = [ToDoItem]()
    
    //MARK:- METHOD ADD TASK
    func addTask(_ item: ToDoItem) {
        tasks.append(item)
    }
    //MARK:- METHOD REMOVE TASK
    func removeTask(at id: String)  {
        guard let index = tasks.firstIndex(where: { $0.taskId == id }) else { return }
        tasks.remove(at: index)
    }
    //MARK:- METHOD SAVE ALL TASKS
    func saveAllTasks(at file: String) {
        let tasksDict = tasks.map { $0.json }
        //get file's url
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
         let fileUrl = path.appendingPathComponent(file)
        //save array in data
        
        do {
            let data = try JSONSerialization.data(withJSONObject: tasksDict, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error.localizedDescription)
        }
        
    }
    //MARK:- METHOD GET ALL TASKS
    func getAllTasks(from file: String) -> [ToDoItem]? {
        //get file's url
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
         let fileUrl = path.appendingPathComponent(file)
       //data from json's file in array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let tasksItems = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return []
            }
             tasks = ToDoItem.parse(json: tasksItems) ?? []
            return tasks
        } catch  {
            print(error.localizedDescription)
            return []
        }
        
    }
    /*Содержит закрытую для внешнего изменения, но открытую для получения коллекцию TodoItem
     〉Содержит функцию добавления новой задачи 〉Содержит функцию удаления задачи (на основе id) 〉Содержит функцию сохранения всех дел в файл 〉Содержит функцию загрузки всех дел из файла 〉Можем иметь несколько разных файлов*/
}
// читаем джейсон из файла в виде Дата, преобразуем в объект чкрез сериализацию.джейсобдж(дата: )

//вызываем парс
