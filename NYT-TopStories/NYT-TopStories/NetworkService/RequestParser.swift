//
//  RequestParser.swift
//  NYT-TopStories
//
//  Created by ali rahal on 28/05/2023.
//

import Foundation

protocol NetworkResponseParseable {
    func parseResponse<T: Decodable>(data: Data) -> Result<T, ErrorViewModel>
}

struct MyResponseParser: NetworkResponseParseable {
    func parseResponse<T: Decodable>(data: Data) -> Result<T, ErrorViewModel> {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(ErrorViewModel(message: error.localizedDescription))
        }
    }
}
