//
//  MainViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

struct FetchTaskToken: Equatable {
    var articles: String
    var token: Date
}

enum Country: String, CaseIterable {
    case us  // США
    case gb  // Великобритания
    case de  // Германия
    case fr  // Франция
    case ru  // Россия
    case cn  // Китай
    case jp  // Япония
    case br  // Бразилия
    case au  // Австралия
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
    @Published var categoryNewsPhase: DataFetchPhase<[ArticleDTO]> = .empty
    @Published var recomendedNewsPhase: DataFetchPhase<[ArticleDTO]> = .empty
    
    @Published var fetchTaskToken: FetchTaskToken
    @Published var errorMessage: String? = nil
    @Published var selectedOrder: DisplayOrderType = .alphabetical
    @Published var searchText: String = ""
    @Published var selectedCategory: Categories = .top
    @Published var categories: [Categories] = []
    
    private let timeIntervalForUpdateCache: TimeInterval = 7 * 24 * 60 * 60
    private let cache: DiskCache<[ArticleDTO]>
    private let country: Country = .gb
    private let newsAPIManager: INewsAPIManager
    private let storageManager = StorageManager.shared
    
    // MARK: - Computed Properties
    private var sortedArticles: [ArticleDTO] {
        guard let articles = categoryNewsPhase.value else { return [] }
        switch selectedOrder {
        case .alphabetical:
            
            return articles.sorted(by: { $0.title < $1.title })
        case .favoriteFirst:
            return articles.sorted { $0.isFavorite && !$1.isFavorite }
        }
    }
    
    private var filteredArticles: [ArticleDTO] {
        guard let articles = recomendedNewsPhase.value else { return []}
        return articles.filter { article in
            categories.contains { $0.rawValue == article.category?.first }
        }
    }
    
    var error: Error? {
        if case let .failure(error) = categoryNewsPhase {
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
    func getCategoryNews() -> [ArticleDTO] { sortedArticles }
    
    func getRecomendedNews() -> [ArticleDTO] { filteredArticles }
    

    /// Cancels the error alert and refreshes the data.
    func cancelErrorAlert() {
        Task {
            await fetchCategoryNews(ignoreCache: true)
        }
    }
    
    /// Refreshes the cache and updates the fetch task token.
    func refreshTask() async {
        await cache.removeValue(forKey: fetchTaskToken.articles)
        fetchTaskToken.token = Date()
    }
    
    // MARK: - Fetch All News
    func fetchCategoryNews(ignoreCache: Bool = false) async {
        categoryNewsPhase = .empty
        do {
            if !ignoreCache,
               let cachedArticles = await cache.value(forKey: fetchTaskToken.articles) {
                print("CACHE HIT")
           
                categoryNewsPhase = .success(cachedArticles)
            } else {
                let articlesFromAPI = try await fetchCategoryArticlesFromAPI()
                print("CACHE MISSED")
                categoryNewsPhase = .success(articlesFromAPI)
            }
        } catch {
            categoryNewsPhase = .failure(error)
        }
    }
    
    private func fetchCategoryArticlesFromAPI() async throws -> [ArticleDTO] {
        let articles = try await newsAPIManager.getNews(with: country.rawValue, selectedCategory.rawValue) ?? []
        await cache.setValue(articles, forKey: selectedCategory.rawValue)
        try? await cache.saveToDisk()
        return articles
    }
//    MARK: - Recomended News
    func fetchRecomendedNews(ignoreCache: Bool = false) async {
           recomendedNewsPhase = .empty
           
           do {
               if !ignoreCache,
             let cachedArticles = await cache.value(forKey: "recomendedNews") {
                   print("CACHE RecomendedNews HIT\(cachedArticles)")
                   
                   recomendedNewsPhase = .success(cachedArticles)
               } else {
                   let articlesFromAPI = try await fetchAllArticlesFromAPI()
                   print("CACHE RecomendedNews MISSED")
                   recomendedNewsPhase = .success(articlesFromAPI)
               }
           } catch {
               recomendedNewsPhase = .failure(error)
           }
       }
    
    private func fetchAllArticlesFromAPI() async throws -> [ArticleDTO] {
        let allArticles = try await newsAPIManager.getTopNews(with: country.rawValue) ?? []
        print("CACHE RecomendedNews MISSED \(allArticles)")
        await cache.setValue(allArticles, forKey: "recomendedNews")
        try? await cache.saveToDisk()
        return allArticles
    }
    

    // MARK: - Load Categories
    func loadCategories() {
        self.categories = storageManager.loadCategories() ?? []
    }
   

    // MARK: - Fetch News with Search

    
}
