//
//  WebServiceTests.swift
//  EnsembleProjectATests
//
//  Created by Grishma Dave on 22/07/24.
//

import XCTest
import Combine


@testable import EnsembleProjectA


class WebServiceTests: XCTestCase {
    
    var webService: WebService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        webService = WebService(urlSession: urlSession)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        webService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testDispatchSuccess() {
        // Given
        let expectedResponse = ["Title": "Inception", "Year": "2010", "Genre": "Action, Adventure, Sci-Fi"]
        MockURLProtocol.requestHandler = { request in
            let data = try! JSONSerialization.data(withJSONObject: expectedResponse, options: [])
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        let router = Router.searchMovie(query: "Inception")
        
        // When
        let expectation = self.expectation(description: "Success response")
        var result: [String: String]?
        var receivedError: NetworkRequestError?
        
        webService.dispatch([String: String].self, router: router)
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
        XCTAssertEqual(result, expectedResponse)
        XCTAssertNil(receivedError)
    }
    
    func testDispatchFailure() {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            let data = Data()
            return (response, data)
        }
        
        let router = Router.searchMovie(query: "NonexistentMovie")
        
        // When
        let expectation = self.expectation(description: "Failure response")
        var result: [String: String]?
        var receivedError: NetworkRequestError?
        
        webService.dispatch([String: String].self, router: router)
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
