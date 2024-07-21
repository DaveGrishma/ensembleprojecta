//
//  Router.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import Foundation
protocol APIRouter {
    var path: String { get }
    var methodType: HTTPMethod { get }
}

enum Router: APIRouter {
    case searchMovie(query: String)
}

// MARK: - API Path
extension Router {
    var path: String {
        switch self {
        case .searchMovie(let query):
            return "https://www.omdbapi.com/?t=\(query)&apikey=1f85142d"
        }
    }
}

extension Router {
    var methodType: HTTPMethod {
        switch self {
        case .searchMovie:
            return .get
        }
    }
}
