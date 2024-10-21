//
//  NewsAPIManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

final class NewsAPIManager: NetworkManager {

    
    // MARK: - Initializer
    init() {
        // Define base URL for the news API
        let baseURL = URL(string: "https://newsapi.org/")!
        
        // Create middlewares
        let authorizationMiddleware = AuthorizationMiddleware(token: "2b9cf27ea13e45eb89926c533fb14c6b")
        
        // Initialize API client with base URL and middleware
        let apiClient = APIClient(
            baseUrl: baseURL,
            middlewares: [authorizationMiddleware]
        )
        
        super.init(apiClient: apiClient)
    }
    
    func getNews() async throws -> [ArticleDTO] {
        let apiSpec: NewsAPISpec = .getNews
        let news = try await apiClient?.sendRequest(apiSpec)
        return news as? [ArticleDTO] ?? []
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

