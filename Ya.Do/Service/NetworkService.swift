//
//  NetworkService.swift
//  Ya.Do
//
//  Created by msc on 27.06.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData()
}
class NetworkService {
    private let api: APIClientclass
    weak var allTasksVC: AllTasksViewController?

    init(api: APIClientclass) {
        self.api = api
    }
}

extension NetworkService: NetworkServiceProtocol {
    func fetchData() {
        api.fetchData { result in
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
