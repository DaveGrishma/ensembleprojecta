//
//  MockMovieService.swift
//  EnsembleProjectATests
//
//  Created by Grishma Dave on 22/07/24.
//

import Foundation
import Combine
@testable import EnsembleProjectA

class MockMovieService: MovieServiceType {
    var searchResponse: AnyPublisher<SearchResponse, NetworkRequestError>?
    
    func searchMovie(query: String) -> AnyPublisher<SearchResponse, NetworkRequestError> {
        return searchResponse ?? Fail(error: .unknownError).eraseToAnyPublisher()
    }
}
