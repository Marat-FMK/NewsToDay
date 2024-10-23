//
//  MainViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//
import Kingfisher
import Foundation

struct FetchTaskToken: Equatable {
    var articles: String
    var token: Date
}

enum DisplayOrderType: CaseIterable {
    case alphabetical
    case favoriteFirst

    var name: String {
        switch self {
        case .alphabetical:
            return "Alphabetical"
        case .favoriteFirst:
            return "Favorite First"
        }
    }
}

@MainActor
final class MainViewModel: ObservableObject {
    @Published var phase: DataFetchPhase<[ArticleDTO]> = .empty
    @Published var fetchTaskToken: FetchTaskToken
    @Published var errorMessage: String? = nil
    @Published var selectedOrder: DisplayOrderType = .alphabetical
    @Published var searchText: String = ""
    
    private let timeIntervalForUpdateCache: TimeInterval = 7 * 24 * 60 * 60
    private let cache: DiskCache<[ArticleDTO]>
    
    private let newsAPIManager: INewsAPIManager
    
    // MARK: - Computed Properties
    private var sortedArticles: [ArticleDTO] {
        guard let articles = phase.value else { return [] }
        switch selectedOrder {
        case .alphabetical:
            
            return articles.sorted(by: { $0.title < $1.title })
        case .favoriteFirst:
            return articles.sorted { $0.isFavorite && !$1.isFavorite }
        }
    }
    
    var error: Error? {
        if case let .failure(error) = phase {
            return error
        }
        return nil
    }
    
    // MARK: - Initializer with Dependency Injection
    init(newsAPIManager: INewsAPIManager) {
        self.newsAPIManager = newsAPIManager
        
        self.fetchTaskToken = FetchTaskToken(articles: "TopNews", token: Date())
        self.cache = DiskCache<[ArticleDTO]>(
            filename: "xca_top_news",
            expirationInterval: timeIntervalForUpdateCache
        )
        Task(priority: .high) {
            try? await cache.loadFromDisk()
        }
    }
    
    // MARK: - Methods
    func getTopNews() -> [ArticleDTO] { sortedArticles }
    
    
    // MARK: - Fetch All News
    func fetchTopNews(ignoreCache: Bool = false) async {
        phase = .empty
        do {
            if !ignoreCache,
               let cachedArticles = await cache.value(forKey: fetchTaskToken.articles) {
                print("CACHE HIT")
                phase = .success(cachedArticles)
            } else {
                let articlesFromAPI = try await fetchArticlesFromAPI()
                print("CACHE MISSED")
                phase = .success(articlesFromAPI)
            }
            
            
        } catch {
            phase = .failure(error)
        }
    }
    
    /// Cancels the error alert and refreshes the data.
    func cancelErrorAlert() {
        Task {
            await fetchTopNews(ignoreCache: true)
        }
    }
    
    /// Refreshes the cache and updates the fetch task token.
    func refreshTask() async {
        await cache.removeValue(forKey: fetchTaskToken.articles)
        fetchTaskToken.token = Date()
    }
    
    private func fetchArticlesFromAPI() async throws -> [ArticleDTO] {
        let articlesFromAPI = try await newsAPIManager.getNews().results
        await cache.setValue(articlesFromAPI, forKey: fetchTaskToken.articles)
        try? await cache.saveToDisk()
        return articlesFromAPI
    }
    
    // MARK: - Fetch News by Category
   

    // MARK: - Fetch News with Search

}
