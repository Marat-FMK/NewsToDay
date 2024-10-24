//
//  NewsAPISpec.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - NewsAPISpec Enum
enum NewsAPISpec: APISpec {
    case getCategoryNews(country: String, category: String)
    case getTopNewsFor(country: String)
    case getNewsWith(searchText: String)
    
    // MARK: - Base URL Path
    private var path: String {
        switch self {
        case .getCategoryNews, .getTopNewsFor:
            return "/api/1/news"
        case .getNewsWith:
            return "/api/1/news"
        }
    }
    
    // MARK: - Query Items
    private var queryItems: [URLQueryItem] {
        switch self {
        case .getCategoryNews(let country, let category):
            return [
                URLQueryItem(name: "country", value: country),
                URLQueryItem(name: "category", value: category)
            ]
        case .getTopNewsFor(let country):
            return [
                URLQueryItem(name: "country", value: country),
            ]
        case .getNewsWith(let searchText):
            return [
                URLQueryItem(name: "q", value: searchText),
            ]
        }
    }
    
    // MARK: - Endpoint
    var endpoint: String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsdata.io"
        components.path = path
        components.queryItems = queryItems
        return components.url?.absoluteString ?? ""
    }
    
    // MARK: - HTTP Method
    var method: HttpMethod {
        return .get
    }
    
    // MARK: - Return Type
    var returnType: DecodableType.Type {
        return NewsApiResponseDTO.self
    }
    
    // MARK: - Request Body
    var body: Data? {
        return nil
    }
}
