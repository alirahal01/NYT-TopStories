//
//  NetworkService.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import Foundation
import Combine

protocol NetworkServiceable {
    func getArticles() -> AnyPublisher<[Article], ErrorViewModel>
}

class NetworkService: NetworkServiceable {

    let urlSession: URLSession
    let baseURLString: String

    init(urlSession: URLSession = .shared, baseURLString: String) {
        self.urlSession = urlSession
        self.baseURLString = baseURLString
    }
    
    internal  func getArticles() -> AnyPublisher<[Article], ErrorViewModel> {
        let section = "home"
        let url = "\(URLConstants.baseUrl)\(URLConstants.top_stories_url)\(section).json"

        guard var components = URLComponents(string: url) else {
            print("Error: cannot create URLComponents")
            return Just<[Article]>([])
                .setFailureType(to: ErrorViewModel.self)
                .eraseToAnyPublisher()
        }
        components.queryItems = [URLQueryItem(name: "api-key", value: "ye9Qka4i7xQlUmH8ckem3ohhu6JucArD")]

        guard let url = components.url else {
            print("Error: cannot create URL")
            return Just<[Article]>([])
                .setFailureType(to: ErrorViewModel.self)
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .map { $0.articles ?? [] }
            .mapError { ErrorViewModel(message: $0.localizedDescription) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
