//
//  MovieServices.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//
import Combine
import Foundation

protocol MovieServiceType {
    func searchMovie(query: String) -> AnyPublisher<SearchResponse,NetworkRequestError>
}

class MovieServices: MovieServiceType {
    private let webService: WebServiceType
    init(webService: WebServiceType) {
        self.webService = webService
    }
    
    func searchMovie(query: String) -> AnyPublisher<SearchResponse, NetworkRequestError> {
        webService.dispatch(SearchResponse.self, router: .searchMovie(query: query))
    }
}
