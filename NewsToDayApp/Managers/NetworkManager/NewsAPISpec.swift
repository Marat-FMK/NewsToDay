//
//  NewsAPISpec.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - NewsAPISpec Enum
enum NewsAPISpec: APIClient.APISpec {
    case getNews
    case getNewsBy(category: String)
    case getNewsWith(searchText: String)
    
    // MARK: - Base URL Path
    private var path: String {
        switch self {
        case .getNews, .getNewsBy:
            return "/v2/top-headlines"
        case .getNewsWith:
            return "/v2/everything"
        }
    }
    
    // MARK: - Query Items
    private var queryItems: [URLQueryItem] {
        switch self {
        case .getNews:
            return [URLQueryItem(name: "country", value: "us")]
        case .getNewsBy(let category):
            return [
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "category", value: category)
            ]
        case .getNewsWith(let searchText):
            return [
                URLQueryItem(name: "q", value: searchText),
                URLQueryItem(name: "country", value: "us")
            ]
        }
    }
    
    // MARK: - Endpoint
    var endpoint: String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = path
        components.queryItems = queryItems
        return components.url?.absoluteString ?? ""
    }
    
    // MARK: - HTTP Method
    var method: APIClient.HttpMethod {
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
