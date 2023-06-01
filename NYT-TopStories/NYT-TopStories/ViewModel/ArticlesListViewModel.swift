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
    
    private var cancellable: AnyCancellable?
    private let networkService: NetworkClient?
    @Published var articlesData: [ArticleData] = []
    @Published private(set) var state: LoadingState<LoadedViewModel> = .idle
    @Published var showErrorAlert = false
    
    init(networkService: NetworkClient? = nil) {
        self.networkService = networkService
    }
    
    func LoadData(section: Section? = nil) {
        guard state != .loading else {
            return
        }
        state = .loading
        let queryItems = [
            URLQueryItem(name: "api-key", value: "ye9Qka4i7xQlUmH8ckem3ohhu6JucArD"),
        ]
        let fallBackURL = URL(string: URLConstants.baseUrl)!
        guard let section = section else { return }
        let url = URL(string: URLConstants.baseUrl) ?? fallBackURL
        let requestBuilder = RequestBuilder(baseURL: url, path: Path(components: ["svc","topstories","v2","\(section.rawValue).json"]), httpMethod: .get,queryItems: queryItems)
        let requestExecutor = URLSessionNetworkRequestExecutor()
        let requestParser = MyResponseParser()
        let networkService = DefaultNetworkClient(requestBuilder: requestBuilder, requestExecutor: requestExecutor, requestParser: requestParser)
        cancellable = networkService.fetchData().sink { [weak self] completion in
            if case .failure(let error) = completion {
                DispatchQueue.main.async {
                    self?.showErrorAlert = true
                    self?.state = .failed(ErrorViewModel(message: error.localizedDescription))
                }
                
            }
        } receiveValue: { [weak self] (result: Result<APIResponse, ErrorViewModel>) in
            switch result {
            case .success(let response):
                let articles = response.articles ?? []
                if articles.count != 0 {
                    let articlesData = articles.map { ArticleData(id: $0.id, title: $0.title, caption: $0.abstract, imageURL: $0.multimedia?[2].url, publishedDate: $0.publishedDate)}
                    DispatchQueue.main.async {
                        self?.articlesData = articlesData
                        self?.state = .success(LoadedViewModel(id: UUID().uuidString, articlesData: articlesData))
                    }
                }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
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
