//
//  NewsAPIManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

final class NewsAPIManager: NetworkManager {
    
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

