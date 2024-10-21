//
//  MainViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    @Published var articles: [ArticleDTO] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let newsAPIManager: INewsAPIManager
    
    // MARK: - Initializer with Dependency Injection
    init(newsAPIManager: INewsAPIManager) {
        self.newsAPIManager = newsAPIManager
        
        print(articles.count)
    }
    
    // MARK: - Fetch All News
    func fetchNews() async {
        isLoading = true
        errorMessage = nil
        do {
            let news = try await newsAPIManager.getNews()
            articles = news.articles
        } catch {
            errorMessage = "Failed to load news: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    // MARK: - Fetch News by Category
    func fetchNews(by category: String) async {
        isLoading = true
        errorMessage = nil
        do {
            if let news = try await newsAPIManager.getNews(by: category) {
                articles = news
            }
        } catch {
            errorMessage = "Failed to load news: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    // MARK: - Fetch News with Search
    func fetchNews(with searchText: String) async {
        isLoading = true
        errorMessage = nil
        do {
            if let news = try await newsAPIManager.getNews(with: searchText) {
                articles = news
            }
        } catch {
            errorMessage = "Failed to load news: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
