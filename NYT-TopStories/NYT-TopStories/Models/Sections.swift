//
//  Sections.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import Foundation

///Article Sections - Categories - We need this in order to filter our requests
enum Section: String, CaseIterable {
    case home
    case arts
    case automobiles
    case books
    case business
    case fashion
    case food
    case health
    case insider
    case magazine
    case movies
    case obituaries
    case opinion
    case politics
    case realestate
    case science
    case sports
    case sundayreview
    case technology
    case theater
    case tMagazine = "t-magazine"
    case travel
    case upshot
    case us
    case world
    
    /// String preferred for section title on the screen.
    var sectionName: String {
        if self == .realestate {
            return "Real Estate"
        }
        if self == .sundayreview {
            return "Sunday Review"
        }
        return rawValue.capitalized
    }
}
