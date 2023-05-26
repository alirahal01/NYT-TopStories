//
//  Article.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import Foundation

// MARK: - Article
struct Article: Codable {
    var title, abstract: String?
    var url: String?
    var shortURL: String?
    var authors: [String]?
    var multimedia: [Multimedia]?
    /// Publication date of the article.
    let publishedDate: String?
    private enum CodingKeys : String, CodingKey {
        case title, authors = "perFacet", abstract, url, shortURL, multimedia, publishedDate = "published_date"
    }
    
}
