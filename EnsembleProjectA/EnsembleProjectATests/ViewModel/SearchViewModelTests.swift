//
//  SearchViewModelTests.swift
//  EnsembleProjectATests
//
//  Created by Grishma Dave on 22/07/24.
//


import XCTest
import Combine

@testable import EnsembleProjectA


class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var mockMovieService: MockMovieService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockMovieService = MockMovieService()
        viewModel = SearchViewModel(movieServices: mockMovieService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockMovieService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSearchMovieSuccess() {
        // Given
        let expectedResponse = SearchResponse(
            title: "Inception",
            year: "2010",
            rated: "PG-13",
            released: "16 Jul 2010",
            runtime: "148 min",
            genre: "Action, Adventure, Sci-Fi",
            director: "Christopher Nolan",
            writer: "Christopher Nolan",
            actors: "Leonardo DiCaprio, Joseph Gordon-Levitt, Ellen Page",
            plot: "A thief who steals corporate secrets through the use of dream-sharing technology...",
            language: "English, Japanese, French",
            country: "USA, UK",
            awards: "Won 4 Oscars. Another 152 wins & 204 nominations.",
            poster: "https://example.com/poster.jpg",
            ratings: [Rating(source: "Internet Movie Database", value: "8.8/10")],
            metascore: "74",
            imdbRating: "8.8",
            imdbVotes: "2,000,000",
            imdbID: "tt1375666",
            type: "movie",
            dvd: "07 Dec 2010",
            boxOffice: "$292,576,195",
            production: "Syncopy",
            website: "N/A",
            response: "True"
        )
        
        mockMovieService.searchResponse = Just(expectedResponse)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Search movie success")
        var receivedResponse: SearchResponse?
        
        viewModel.searchResult
            .sink(receiveCompletion: { _ in },
                  receiveValue: { response in
                receivedResponse = response
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.searchMovie(query: "Inception")
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(viewModel.numberOfMovies(), 1)
        XCTAssertEqual(viewModel.movieAt(index: 0).title, expectedResponse.title)
        XCTAssertEqual(receivedResponse?.title, expectedResponse.title)
    }
    
    
    func testClearSearch() {
        // Given
        let expectedResponse = SearchResponse(
            title: "Inception",
            year: "2010",
            rated: "PG-13",
            released: "16 Jul 2010",
            runtime: "148 min",
            genre: "Action, Adventure, Sci-Fi",
            director: "Christopher Nolan",
            writer: "Christopher Nolan",
            actors: "Leonardo DiCaprio, Joseph Gordon-Levitt, Ellen Page",
            plot: "A thief who steals corporate secrets through the use of dream-sharing technology...",
            language: "English, Japanese, French",
            country: "USA, UK",
            awards: "Won 4 Oscars. Another 152 wins & 204 nominations.",
            poster: "https://example.com/poster.jpg",
            ratings: [Rating(source: "Internet Movie Database", value: "8.8/10")],
            metascore: "74",
            imdbRating: "8.8",
            imdbVotes: "2,000,000",
            imdbID: "tt1375666",
            type: "movie",
            dvd: "07 Dec 2010",
            boxOffice: "$292,576,195",
            production: "Syncopy",
            website: "N/A",
            response: "True"
        )
        
        mockMovieService.searchResponse = Just(expectedResponse)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()
        
        // When
        viewModel.searchMovie(query: "Inception")
        
        let expectation = self.expectation(description: "Clear search result")
        viewModel.searchResult
            .sink(receiveCompletion: { _ in },
                  receiveValue: { response in
                if response == nil {
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)
        
        viewModel.clearSearch()
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(viewModel.numberOfMovies(), 0)
    }
}
