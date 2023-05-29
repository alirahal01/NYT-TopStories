//
//  RequestExecutor.swift
//  NYT-TopStories
//
//  Created by ali rahal on 28/05/2023.
//

import Foundation
import Combine

protocol NetworkRequestExecutable {
    func executeRequest(request: URLRequest) -> AnyPublisher<Data, Error>
}

class URLSessionNetworkRequestExecutor: NetworkRequestExecutable {
    func executeRequest(request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
