//
//  RequestBuilder.swift
//  NYT-TopStories
//
//  Created by ali rahal on 28/05/2023.
//

import Foundation

protocol URLRequestConvertible {
    func urlRequest() throws -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct RequestBuilder: URLRequestConvertible {
    private let baseURL: URL
    private let path: Path
    private let httpMethod: HTTPMethod
    private let queryItems: [URLQueryItem]?
    
    init(baseURL: URL, path: Path, httpMethod: HTTPMethod, queryItems: [URLQueryItem]? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.queryItems = queryItems
    }
    
    func urlRequest() throws -> URLRequest {
        let url = "\(baseURL.appendingPathComponent(path.stringValue))"
        var components = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        // Customize headers, add additional properties to the request, etc.
        return request
    }
}

// Example implementation of the Path type
struct Path {
    let components: [String]
    
    var stringValue: String {
        let pathString = components.joined(separator: "/")
        return pathString
    }
}
