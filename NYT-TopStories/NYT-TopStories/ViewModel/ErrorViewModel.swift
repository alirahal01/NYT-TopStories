//
//  ArticleError.swift
//  NYT-TopStories
//
//  Created by ali rahal on 27/05/2023.
//

import Foundation

struct ErrorViewModel: Equatable {
    let message: String
    
    static func == (lhs: ErrorViewModel, rhs: ErrorViewModel) -> Bool {
        return lhs.message == rhs.message
    }
}
