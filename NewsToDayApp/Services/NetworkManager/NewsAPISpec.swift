//
//  NewsAPISpec.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - NewsAPISpec Enum
enum NewsAPISpec: APIClient.APISpec {
    // API Cases for different news requests
    case getNews
    case getNewsBy(category: String)
    case getNewsWith(searchText: String)
    
    // MARK: - Endpoint
    // Determines the API endpoint based on the case
    var endpoint: String {
        switch self {
        case .getNews:
            return "" // Base endpoint for general news
        case .getNewsBy(category: let category):
            return "" // Endpoint filtered by category
        case .getNewsWith(searchText: let searchText):
            return "" // Endpoint with search text
        }
    }
    
    // MARK: - HTTP Method
    // Determines the HTTP method (e.g., GET) for each request
    var method: APIClient.HttpMethod {
        switch self {
        case .getNews:
            return .get
        case .getNewsBy(category: let category):
            return .get
        case .getNewsWith(searchText: let searchText):
            return .get
        }
    }
    
    // MARK: - Return Type
    // Defines the expected return type for the API response
    var returnType: DecodableType.Type {
        switch self {
        case .getNews:
            return [ArticleDTO].self // Returns a list of articles
        case .getNewsBy(category: let category):
            return [ArticleDTO].self // Returns a list of articles filtered by category
        case .getNewsWith(searchText: let searchText):
            return [ArticleDTO].self // Returns a single article based on search
        }
    }
    
    // MARK: - Request Body
    // Provides the body of the request if applicable
    var body: Data? {
        switch self {
        case .getNews:
            return nil // No body for general news request
        case .getNewsBy(category: let category):
            return nil // No body needed for category-based request
        case .getNewsWith(searchText: let searchText):
            return try? JSONEncoder().encode(searchText) // Encodes search text as body
        }
    }
}
