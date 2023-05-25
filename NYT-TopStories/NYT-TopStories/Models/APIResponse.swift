//
//  APIResponse.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import Foundation

// MARK: - APIResponse
struct APIResponse: Codable {
    var numResults: Int?
    var articles: [Article]?
    
    private enum CodingKeys : String, CodingKey {
        case numResults, articles = "results"
    }
}
