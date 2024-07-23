//
//  WebService.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import Foundation
import Combine

protocol WebServiceType {
    func dispatch<ReturnType: Codable>(_ type: ReturnType.Type, router: Router) -> AnyPublisher<ReturnType, NetworkRequestError>
}

struct WebService: WebServiceType {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Dispatches an URLRequest and returns a publisher
    /// - Parameter request: URLRequest
    /// - Returns: A publisher with the provided decoded data or an error
    func dispatch<ReturnType: Codable>(_ type: ReturnType.Type, router: Router) -> AnyPublisher<ReturnType, NetworkRequestError> {
        
        guard let request = createRequest(router: router) else { return Fail(error: NetworkRequestError.invalidRequest).eraseToAnyPublisher() }
        
        return urlSession
            .dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ data, response in
                
                guard let response = response as? HTTPURLResponse else {
                    throw httpError(0)
                }
                
                print("[\(response.statusCode)] '\(request.url!)'")
                
                if !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }
                
                return data
            })
            .receive(on: DispatchQueue.main)
            .decode(type: type.self, decoder: JSONDecoder())
            .mapError { error in
                return handleError(error)
            }
            .eraseToAnyPublisher()
    }
    
    private func createRequest(router: Router) -> URLRequest? {
        guard let url = URL(string: router.path) else { return nil }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = router.methodType.rawValue
        print("[\(request.httpMethod!)] '\(request.url!)'")
        return request
    }
}

// MARK: - Error Handling

enum NetworkRequestError: LocalizedError, Equatable {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError(description: String)
    case urlSessionFailed(_ error: URLError)
    case timeOut
    case unknownError
}

extension WebService {
    /// Parses a HTTP StatusCode and returns a proper error
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Mapped Error
    private func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    /// Parses URLSession Publisher errors and return proper ones
    /// - Parameter error: URLSession publisher error
    /// - Returns: Readable NetworkRequestError
    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case let decodingError as DecodingError:
            return handleDecodingError(decodingError)
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }
    
    private func handleDecodingError(_ error: DecodingError) -> NetworkRequestError {
        switch error {
        case .typeMismatch(let type, let context):
            return .decodingError(description: "Type '\(type)' mismatch: \(context.debugDescription)")
        case .valueNotFound(let type, let context):
            return .decodingError(description: "Value not found for type '\(type)': \(context.debugDescription)")
        case .keyNotFound(let key, let context):
            return .decodingError(description: "Key '\(key)' not found: \(context.debugDescription)")
        case .dataCorrupted(let context):
            return .decodingError(description: "Data corrupted: \(context.debugDescription)")
        @unknown default:
            return .decodingError(description: "Unknown decoding error")
        }
    }
}
