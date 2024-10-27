//
//  NewsAPIManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - NewsAPIManagerProtocol
protocol INewsAPIManager {
    func getNews(with country: String,_ category: String) async throws -> NewsApiResponseDTO?
    func getTopNews(with country: String) async throws -> NewsApiResponseDTO?
    func getSearchedNews(with searchText: String) async throws -> NewsApiResponseDTO?
}

final class NewsAPIManager: APIManager, INewsAPIManager {
    
    // MARK: - Initializer
    init() {
        // Create middlewares
#warning("apiKey")
        let authorizationMiddleware = AuthorizationMiddleware(apiKey: "pub_40669167f5b9c344181f2c7e28f917505ffd7")
        // Initialize API client with base URL and middleware
        let apiClient = APIClient(middlewares: [authorizationMiddleware])
        super.init(apiClient: apiClient)
    }
    
    func getNews(with country: String, _ category: String) async throws -> NewsApiResponseDTO? {
        let apiSpec: NewsAPISpec = .getCategoryNews(country: country, category: category)
        do {
            let news = try await apiClient?.sendRequest(apiSpec)
            return news as? NewsApiResponseDTO
        } catch {
            print(error)
            return nil
        }
    }
    
    func getTopNews(with country: String) async throws ->  NewsApiResponseDTO? {
        let apiSpec: NewsAPISpec = .getTopNewsFor(country: country)
        do {
            let news = try await apiClient?.sendRequest(apiSpec)
            return news as?  NewsApiResponseDTO
        } catch {
            print(error)
            return nil
        }
    }
    
    func getSearchedNews(with searchText: String) async throws -> NewsApiResponseDTO? {
        let apiSpec: NewsAPISpec = .getNewsWith(searchText: searchText)
        do {
            let news = try await apiClient?.sendRequest(apiSpec)
            return news as?  NewsApiResponseDTO
        } catch {
            print(error)
            return nil
        }
    }
}
