//
//  NewsAPISpec.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

enum NewsAPISpec: ApiClient.APISpec {
    case getNews
    case getNewsBy(category: String)
    case getNewsWith(searchText: String)
    
    var endpoint: String {
        switch self {
        case .getNews:
            return ""
        case .getNewsBy(category: let category):
            return ""
        case .getNewsWith(searchText: let searchText):
            return ""
        }
    }
    
    var method: ApiClient.HttpMethod {
        switch self {
        case .getNews:
            return .get
        case .getNewsBy(category: let category):
            return .get
        case .getNewsWith(searchText: let searchText):
            return .get
        }
    }
    
    var returnType: DecodableType.Type {
        switch self {
        case .getNews:
            return [ArticleDTO].self
        case .getNewsBy(category: let category):
            return [ArticleDTO].self
        case .getNewsWith(searchText: let searchText):
            return ArticleDTO.self
        }
    }
    
    var body: Data? {
        switch self {
        case .getNews:
            return nil
        case .getNewsBy(category: let category):
            return nil
        case .getNewsWith(searchText: let searchText):
            return try? JSONEncoder().encode(searchText)
        }
    }
}
