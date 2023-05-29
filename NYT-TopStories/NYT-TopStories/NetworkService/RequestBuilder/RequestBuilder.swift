//
//  RequestBuilder.swift
//  NYT-TopStories
//
//  Created by ali rahal on 28/05/2023.
//

import Foundation

protocol URLRequestConvertible {
    func urlRequest(section: Section) throws -> URLRequest
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
    
    func urlRequest(section: Section) throws -> URLRequest {
        let url = "\(baseURL.appendingPathComponent(path.stringValue))\(section).json"
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
        var pathString = components.joined(separator: "/")
        
        // Ensure the path ends with a forward slash
        if !pathString.hasSuffix("/") {
            pathString += "/"
        }
        
        return pathString
    }
}
