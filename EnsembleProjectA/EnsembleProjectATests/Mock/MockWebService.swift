//
//  MockWebService.swift
//  EnsembleProjectATests
//
//  Created by Grishma Dave on 22/07/24.
//

import Foundation
import Combine
@testable import EnsembleProjectA

class MockWebService: WebServiceType {
    var response: AnyPublisher<Any, NetworkRequestError>?
    
    func dispatch<ReturnType: Codable>(_ type: ReturnType.Type, router: Router) -> AnyPublisher<ReturnType, NetworkRequestError> {
        return response?.compactMap { $0 as? ReturnType }
            .mapError { $0 as! NetworkRequestError }
            .eraseToAnyPublisher() ?? Fail(error: .unknownError).eraseToAnyPublisher()
    }
}
