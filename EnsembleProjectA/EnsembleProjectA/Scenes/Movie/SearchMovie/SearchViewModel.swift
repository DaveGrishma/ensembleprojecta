//
//  SearchViewModel.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import Foundation
import Combine

protocol SearchViewModelType {
    var searchResult: PassthroughSubject<SearchResponse, NetworkRequestError> { get }
    func searchMovie(query: String)
}

class SearchViewModel: SearchViewModelType {
    var cancellable: Set <AnyCancellable> = []
    var searchResult = PassthroughSubject<SearchResponse, NetworkRequestError> ()
    private let movieServices: MovieServiceType
    init(movieServices: MovieServiceType) {
        self.movieServices = movieServices
    }
    func searchMovie(query: String) {
        movieServices.searchMovie(query: query).sink { complition in
            switch complition {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { searchData in
            print(searchData)
        }.store(in: &cancellable)
    }
}
