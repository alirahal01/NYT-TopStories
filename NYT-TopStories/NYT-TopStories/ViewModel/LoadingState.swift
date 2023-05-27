//
//  LoadingState.swift
//  NYT-TopStories
//
//  Created by ali rahal on 27/05/2023.
//

import Foundation

enum LoadingState<LoadedViewModel: Equatable>: Equatable {
    case idle
    case loading
    case failed(ErrorViewModel)
    case success(LoadedViewModel)
}
