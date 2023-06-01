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
    var requestParser: NetworkResponseParseable { get }
    func fetchData<T: Decodable>() -> AnyPublisher<Result<T, ErrorViewModel>, ErrorViewModel>
}

struct DefaultNetworkClient: NetworkClient {
    let requestBuilder: URLRequestConvertible
    let requestExecutor: NetworkRequestExecutable
    let requestParser: NetworkResponseParseable
    var cancellables = Set<AnyCancellable>()
   
    init(requestBuilder: URLRequestConvertible, requestExecutor: NetworkRequestExecutable, requestParser: NetworkResponseParseable) {
        self.requestBuilder = requestBuilder
        self.requestExecutor = requestExecutor
        self.requestParser = requestParser
    }
    
    func fetchData<T: Decodable>() -> AnyPublisher<Result<T, ErrorViewModel>, ErrorViewModel> {
        do {
            let request = try requestBuilder.urlRequest()
            return requestExecutor.executeRequest(request: request)
                .map { data in
                    requestParser.parseResponse(data: data)
                            }
                .mapError { ErrorViewModel(message: $0.localizedDescription) }
                .eraseToAnyPublisher()
        } catch {
            return Fail<Result<T,ErrorViewModel>, ErrorViewModel>(error: error as! ErrorViewModel)
                .eraseToAnyPublisher()
        }
    }
}
