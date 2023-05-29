//
//  NetworkClient.swift
//  NYT-TopStories
//
//  Created by ali rahal on 28/05/2023.
//

import Foundation
import Combine

protocol NetworkClient {
    var requestBuilder: URLRequestConvertible { get }
    var requestExecutor: NetworkRequestExecutable { get }
    func fetchData<T: Decodable>(section: Section) -> AnyPublisher<T,Error>
}

struct DefaultNetworkClient: NetworkClient {
    let requestBuilder: URLRequestConvertible
    let requestExecutor: NetworkRequestExecutable
    var cancellables = Set<AnyCancellable>()
   
    init(requestBuilder: URLRequestConvertible, requestExecutor: NetworkRequestExecutable) {
        self.requestBuilder = requestBuilder
        self.requestExecutor = requestExecutor
    }
    
    func fetchData<T: Decodable>(section: Section) -> AnyPublisher<T,Error> {
        do {
            let request = try requestBuilder.urlRequest(section: .home)
            return requestExecutor.executeRequest(request: request)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { ErrorViewModel(message: $0.localizedDescription) }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
