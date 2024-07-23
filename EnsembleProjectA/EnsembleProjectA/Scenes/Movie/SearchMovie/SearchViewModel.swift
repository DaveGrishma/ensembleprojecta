//
//  SearchViewModel.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import Foundation
import Combine

protocol SearchViewModelType {
    var searchResult: PassthroughSubject<SearchResponse?, NetworkRequestError> { get }
    func searchMovie(query: String)
    func numberOfMovies() -> Int
    func movieAt(index: Int) -> SearchResponse
    func clearSearch()
}

class SearchViewModel: SearchViewModelType {
    
    var cancellable: Set <AnyCancellable> = []
    var searchResultMovies: [SearchResponse] = []
    var searchResult = PassthroughSubject<SearchResponse?, NetworkRequestError> ()
    private let movieServices: MovieServiceType
    init(movieServices: MovieServiceType) {
        self.movieServices = movieServices
    }
    func searchMovie(query: String) {
        movieServices.searchMovie(query: query).sink { [weak self] complition in
            switch complition {
            case .finished:
                break
            case .failure(let error):
                self?.searchResult.send(completion: .failure(error))

            }
        } receiveValue: { [weak self] searchData in
            print(searchData)
            self?.searchResultMovies.removeAll()
            self?.searchResultMovies.append(searchData)
            self?.searchResult.send(searchData)
        }.store(in: &cancellable)
    }
    
    func clearSearch() {
        self.searchResultMovies.removeAll()
        searchResult.send(nil)
    }
    
}

extension SearchViewModel {
    func numberOfMovies() -> Int {
        searchResultMovies.count
    }
    
    func movieAt(index: Int) -> SearchResponse {
        searchResultMovies[index]
    }
}
