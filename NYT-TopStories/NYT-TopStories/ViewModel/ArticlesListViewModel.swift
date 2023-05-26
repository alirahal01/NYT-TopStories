//
//  ArticlesListViewModel.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import Foundation
import Combine

class ArticlesViewModel: ObservableObject {
    
    private var articlesPublisher: AnyCancellable?
    private let networkService: NetworkServiceable
    @Published var articles: [Article] = []
    
    init(networkService: NetworkServiceable) {
        self.networkService = networkService
    }
    
    func LoadData() {
        articlesPublisher = networkService.getArticles().receive(on: DispatchQueue.main).sink { [weak self] completion in
            print(completion)
        } receiveValue: { [weak self] articles in
            self?.articles = articles
        }
    }
    
}
