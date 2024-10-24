//
//  NewsAPIManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - NewsAPIManagerProtocol
protocol INewsAPIManager {
    func getNews(with country: String,_ category: String) async throws -> [ArticleDTO]?
    func getTopNews(with country: String) async throws -> [ArticleDTO]?
    func getNews(with searchText: String) async throws -> [ArticleDTO]?
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
    
    func getNews(with country: String, _ category: String) async throws -> [ArticleDTO]? {
           let apiSpec: NewsAPISpec = .getCategoryNews(country: country, category: category)
           
           print("Requesting news with URL: \(apiSpec.endpoint)")
           
           let news = try await apiClient?.sendRequest(apiSpec)
           return news as? [ArticleDTO]
       }
       
       func getTopNews(with country: String) async throws -> [ArticleDTO]? {
           let apiSpec: NewsAPISpec = .getTopNewsFor(country: country)
           
           print("Requesting top news with URL: \(apiSpec.endpoint)")
           
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
           

           print("Requesting search results with URL: \(apiSpec.endpoint)")
           
           do {
               let news = try await apiClient?.sendRequest(apiSpec)
               return news as? [ArticleDTO]
           } catch {
               print(error)
               return nil
           }
       }
   }
