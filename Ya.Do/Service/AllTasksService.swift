//
//  AllTasksService.swift
//  Ya.Do
//
//  Created by msc on 27.06.2021.
//

import Foundation

protocol AllTasksServiceProtocol {
    func fetchData()
}
class AllTasksService {
    private let api: NetworkService
    weak var allTasksVC: AllTasksViewController?

    init(api: NetworkService) {
        self.api = api
    }
}

extension AllTasksService: AllTasksServiceProtocol {
    func fetchData() {
        api.getTasks { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let item):
                    self.allTasksVC?.showData(data: item)
                case .failure:
                    self.allTasksVC?.showError()
                }
            }
        }
    }
}
