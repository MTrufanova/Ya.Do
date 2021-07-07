//
//  Endpoint.swift
//  Ya.Do
//
//  Created by msc on 04.07.2021.
//

import Foundation

enum Endpoint {
    case getTasks
    case postTask
    case updateItem(id: String)
    case removeItem(id: String)
    case putTasks

    var url: URL? {
        var result = "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net"
        switch self {
        case .getTasks:
            result = "\(result)/tasks/"
        case.postTask:
            result = "\(result)/tasks/"
        case .updateItem(let id):
            result = "\(result)/tasks/\(id)"
        case.removeItem(let id):
            result = "\(result)/tasks/\(id)"
        case.putTasks:
            result = "\(result)/tasks/"
        }
        return URL(string: result)
    }
}
