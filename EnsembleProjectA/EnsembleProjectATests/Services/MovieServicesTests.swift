//
//  MovieServicesTests.swift
//  EnsembleProjectATests
//
//  Created by Grishma Dave on 22/07/24.
//

import XCTest
import Combine

@testable import EnsembleProjectA

class MovieServicesTests: XCTestCase {
    
    var movieService: MovieServices!
    var mockWebService: MockWebService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockWebService = MockWebService()
        movieService = MovieServices(webService: mockWebService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        movieService = nil
        mockWebService = nil
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
            plot: "A thief who steals corporate secrets through use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO.",
            language: "English, Japanese, French",
            country: "USA, UK",
            awards: "Won 4 Oscars. Another 153 wins & 220 nominations.",
            poster: "https://example.com/poster.jpg",
            ratings: [
                Rating(source: "Internet Movie Database", value: "8.8/10"),
                Rating(source: "Rotten Tomatoes", value: "86%")
            ],
            metascore: "74",
            imdbRating: "8.8",
            imdbVotes: "1,600,000",
            imdbID: "tt1375666",
            type: "movie",
            dvd: "07 Dec 2010",
            boxOffice: "$292,576,195",
            production: "Warner Bros. Pictures",
            website: "http://inceptionmovie.warnerbros.com/",
            response: "True"
        )
        
        mockWebService.response = Just(expectedResponse)
            .setFailureType(to: NetworkRequestError.self)
            .map { $0 as Any }
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Success response")
        var result: SearchResponse?
        var receivedError: NetworkRequestError?
        
        movieService.searchMovie(query: "Inception")
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { response in
                result = response
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(result?.title, expectedResponse.title)
        XCTAssertEqual(result?.year, expectedResponse.year)
        XCTAssertEqual(result?.rated, expectedResponse.rated)
        XCTAssertEqual(result?.released, expectedResponse.released)
        XCTAssertEqual(result?.runtime, expectedResponse.runtime)
        XCTAssertEqual(result?.genre, expectedResponse.genre)
        XCTAssertEqual(result?.director, expectedResponse.director)
        XCTAssertEqual(result?.writer, expectedResponse.writer)
        XCTAssertEqual(result?.actors, expectedResponse.actors)
        XCTAssertEqual(result?.plot, expectedResponse.plot)
        XCTAssertEqual(result?.language, expectedResponse.language)
        XCTAssertEqual(result?.country, expectedResponse.country)
        XCTAssertEqual(result?.awards, expectedResponse.awards)
        XCTAssertEqual(result?.poster, expectedResponse.poster)
        XCTAssertEqual(result?.metascore, expectedResponse.metascore)
        XCTAssertEqual(result?.imdbRating, expectedResponse.imdbRating)
        XCTAssertEqual(result?.imdbVotes, expectedResponse.imdbVotes)
        XCTAssertEqual(result?.imdbID, expectedResponse.imdbID)
        XCTAssertEqual(result?.type, expectedResponse.type)
        XCTAssertEqual(result?.dvd, expectedResponse.dvd)
        XCTAssertEqual(result?.boxOffice, expectedResponse.boxOffice)
        XCTAssertEqual(result?.production, expectedResponse.production)
        XCTAssertEqual(result?.website, expectedResponse.website)
        XCTAssertEqual(result?.response, expectedResponse.response)
        XCTAssertNil(receivedError)
    }
    
    func testSearchMovieFailure() {
        // Given
        mockWebService.response = Fail(outputType: Any.self, failure: NetworkRequestError.badRequest)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Failure response")
        var result: SearchResponse?
        var receivedError: NetworkRequestError?
        
        movieService.searchMovie(query: "NonexistentMovie")
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { response in
                result = response
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(result)
        XCTAssertEqual(receivedError, .badRequest)
    }
}
