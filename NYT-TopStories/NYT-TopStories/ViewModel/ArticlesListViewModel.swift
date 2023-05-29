//
//  ArticlesListViewModel.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import Foundation
import Combine
import SwiftUI

class ArticlesViewModel: ObservableObject {
    
    private var articlesPublisher: AnyCancellable?
    private let networkService: NetworkClient
    @Published var articlesData: [ArticleData] = []
    @Published private(set) var state: LoadingState<LoadedViewModel> = .idle
    @Published var showErrorAlert = false
    
    init(networkService: NetworkClient) {
        self.networkService = networkService
    }
    
    func LoadData() {
        guard state != .loading else {
            return
        }

        state = .loading
        articlesPublisher =
        networkService
            .fetchData(section: .home)
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .map { $0.articles ?? [] }
            .mapError { ErrorViewModel(message: $0.localizedDescription) }
            .sink { [weak self] completion in
            if case .failure(let error) = completion {
                DispatchQueue.main.async {
                    self?.showErrorAlert = true
                    self?.state = .failed(ErrorViewModel(message: error.localizedDescription))
                }
                
            }
        } receiveValue: { [weak self] articles in
            if articles.count != 0 {
                let articlesData = articles.map { ArticleData(id: $0.id, title: $0.title, caption: $0.abstract, imageURL: $0.multimedia?[2].url, publishedDate: $0.publishedDate)}
                DispatchQueue.main.async {
                    self?.articlesData = articlesData
                    self?.state = .success(LoadedViewModel(id: UUID().uuidString, articlesData: articlesData))
                }
            }

        }
//        articlesPublisher = networkService.getArticles().receive(on: DispatchQueue.main).sink { [weak self] completion in
//            if case .failure(let error) = completion {
//                self?.showErrorAlert = true
//                self?.state = .failed(ErrorViewModel(message: error.localizedDescription))
//            }
//        } receiveValue: { [weak self] articles in
//            if articles.count != 0 {
//                let articlesData = articles.map { ArticleData(id: $0.id, title: $0.title, caption: $0.abstract, imageURL: $0.multimedia?[2].url, publishedDate: $0.publishedDate)}
//                self?.articlesData = articlesData
//                self?.state = .success(LoadedViewModel(id: UUID().uuidString, articlesData: articlesData))
//            }
//
//        }
    }
    
}

extension ArticlesViewModel {
    struct ArticleData: Identifiable {
        let id: Int?
        let title: String?
        let caption: String?
        let imageURL: String?
        let publishedDate: String?
    }
    
    struct LoadedViewModel: Equatable {
        let id: String
        let articlesData: [ArticleData]
        
        static func == (lhs: ArticlesViewModel.LoadedViewModel, rhs: ArticlesViewModel.LoadedViewModel) -> Bool {
            lhs.id == rhs.id
        }
    }
}
