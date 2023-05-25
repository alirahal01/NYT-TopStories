//
//  NetworkService.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import Foundation
import Combine

protocol NetworkServiceable {
    func getArticles() -> AnyPublisher<[Article], Never>
}

class NetworkService: NetworkServiceable {

    let urlSession: URLSession
    let baseURLString: String

    init(urlSession: URLSession = .shared, baseURLString: String) {
        self.urlSession = urlSession
        self.baseURLString = baseURLString
    }

    func getArticles() -> AnyPublisher<[Article], Never> {

        let urlString = baseURLString + "arts"

        guard let url = URL(string: urlString) else {
            return Just<[Article]>([]).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Article].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
