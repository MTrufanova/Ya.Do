//
//  ModuleBuilder.swift
//  Ya.Do
//
//  Created by msc on 18.07.2021.
//

import UIKit

protocol ModuleBuilderProtocol {
    static func configuredTasksListModule() -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {

    static func configuredTasksListModule() -> UIViewController {
        let view = AllTasksViewController()
        let localService = CoreDataStack()
        let presenter = AllTasksPresenter(view: view, localData: localService)
        view.presenter = presenter
        return view
    }

}
