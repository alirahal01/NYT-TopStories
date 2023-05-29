//
//  NYT_TopStoriesApp.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import SwiftUI

struct URLConstants {
     static let baseUrl = "https://api.nytimes.com"
     static let top_stories_url = "/svc/topstories/v2/"
}

@main
struct NYT_TopStoriesApp: App {
    var body: some Scene {
//        let networkService = NetworkService(baseURLString: "https://api.nytimes.com/svc/topstories/v2/")
        let queryItems = [
            URLQueryItem(name: "api-key", value: "ye9Qka4i7xQlUmH8ckem3ohhu6JucArD"),
        ]
        let fallBackURL = URL(string: "https://api.nytimes.com")!
        let url = URL(string: "https://api.nytimes.com") ?? fallBackURL
        let requestBuilder = RequestBuilder(baseURL: url, path: Path(components: ["svc","topstories","v2"]), httpMethod: .get,queryItems: queryItems)
        let requestExecutor = URLSessionNetworkRequestExecutor()
        let networkService = DefaultNetworkClient(requestBuilder: requestBuilder, requestExecutor: requestExecutor)
        let viewModel = ArticlesViewModel(networkService: networkService)
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
