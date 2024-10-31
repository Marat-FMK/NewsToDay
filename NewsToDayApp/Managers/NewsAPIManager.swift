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
//        pub_5741650ae47f14ee901c90f834235c6a2f182
        let authorizationMiddleware = AuthorizationMiddleware(apiKey: "pub_57416f1c586b36028a9af95ec8390930c5d4f")
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
