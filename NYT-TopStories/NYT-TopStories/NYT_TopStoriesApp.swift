//
//  NYT_TopStoriesApp.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import SwiftUI

struct URLConstants {
     static let baseUrl = "https://api.nytimes.com"
}

@main
struct NYT_TopStoriesApp: App {
    var body: some Scene {
        let viewModel = ArticlesViewModel()
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
