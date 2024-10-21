//
//  NewsAPIManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - NewsAPIManagerProtocol
protocol INewsAPIManager {
    func getNews() async throws -> NewsApiResponseDTO
    func getNews(by category: String) async throws -> [ArticleDTO]?
    func getNews(with searchText: String) async throws -> [ArticleDTO]?
}

final class NewsAPIManager: NetworkManager, INewsAPIManager {

    // MARK: - Initializer
    init() {
        // Create middlewares
#warning("apiKey")
        let authorizationMiddleware = AuthorizationMiddleware(apiKey: "2b9cf27ea13e45eb89926c533fb14c6b")
        // Initialize API client with base URL and middleware
        let apiClient = APIClient(middlewares: [authorizationMiddleware])
        super.init(apiClient: apiClient)
    }
    
    func getNews() async throws -> NewsApiResponseDTO {
        let apiSpec: NewsAPISpec = .getNews
        let news = try await apiClient?.sendRequest(apiSpec)
        return (news as? NewsApiResponseDTO)!
    }
    
    func getNews(by category: String) async throws -> [ArticleDTO]? {
        let apiSpec: NewsAPISpec = .getNewsBy(category: category)
        do {
            let news = try await apiClient?.sendRequest(apiSpec)
            return news as? [ArticleDTO]
        } catch {
            print(error)
            return nil
        }
    }
    
    func getNews(with searchText: String) async throws -> [ArticleDTO]? {
        let apiSpec: NewsAPISpec = .getNewsWith(searchText: searchText)
        do {
            let news = try await apiClient?.sendRequest(apiSpec)
            return news as? [ArticleDTO]
        } catch {
            print(error)
            return nil
        }
    }
}

