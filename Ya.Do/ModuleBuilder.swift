//
//  ModuleBuilder.swift
//  Ya.Do
//
//  Created by msc on 18.07.2021.
//

import UIKit

protocol ModuleBuilderProtocol {
    static func configuredTasksListModule() -> UIViewController
    static func configuredDetailTaskModule(task: TodoItem?, delegate: DetailTaskViewControllerDelegate?) -> UIViewController
    
}

class ModuleBuilder: ModuleBuilderProtocol {

    static func configuredTasksListModule() -> UIViewController {
        let view = AllTasksViewController()
        let localService = CoreDataStack()
        let presenter = AllTasksPresenter(view: view, localData: localService)
        view.presenter = presenter
        return view
    }
    static func configuredDetailTaskModule(task: TodoItem?, delegate: DetailTaskViewControllerDelegate?) -> UIViewController {
        let view = DetailTaskViewController()
        let localService = CoreDataStack()
        let presenter = DetailTaskPresenter(view: view, localData: localService, task: task, delegate: delegate)
        view.presenter = presenter
        return view
    }
}
