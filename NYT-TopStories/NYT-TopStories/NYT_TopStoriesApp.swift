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
        let networkService = NetworkService(baseURLString: "https://api.nytimes.com/svc/topstories/v2/")
        let viewModel = ArticlesViewModel(networkService: networkService)
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
