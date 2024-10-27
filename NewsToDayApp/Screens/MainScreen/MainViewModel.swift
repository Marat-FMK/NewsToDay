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
    
    @Published var searshNewsResults: [ArticleDTO] = []
    
    @Published var fetchTaskToken: FetchTaskToken
    @Published var errorMessage: String? = nil
    @Published var selectedOrder: DisplayOrderType = .alphabetical
    @Published var searchText: String = ""
    @Published var categories: [Categories] = []
    @Published var selectedCategory: Categories = .top {
        didSet {
            Task {
                await fetchCategoryNews()
            }
        }
    }
    
    private let newsAPIManager: INewsAPIManager
    private let bookmarkManager: IBookMarks
    private let storageManager: IUserDefaultManager
    
    private let timeIntervalForUpdateCache: TimeInterval = 7 * 24 * 60 * 60
    private let cache: DiskCache<[ArticleDTO]>
    private let country: Country = .gb
    private var lastSortedOrder: DisplayOrderType?
    private var lastSortedArticles: [ArticleDTO]?
    
    // MARK: - Computed Properties
    private var sortedArticles: [ArticleDTO] {
        guard let articles = categoryNewsPhase.value else { return [] }
        if selectedOrder == lastSortedOrder, let lastSorted = lastSortedArticles {
            return lastSorted
        }
        let sorted = articles.sorted {
            switch selectedOrder {
            case .alphabetical: return $0.title < $1.title
            case .favoriteFirst: return $0.isFavorite && !$1.isFavorite
            }
        }
        lastSortedOrder = selectedOrder
        lastSortedArticles = sorted
        return sorted
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
    init(newsAPIManager: INewsAPIManager,
         bookmardManager: IBookMarks = BookMarksManager.shared,
         storageManager: IUserDefaultManager = StorageManager.shared
    ) {
        self.newsAPIManager = newsAPIManager
        self.bookmarkManager = bookmardManager
        self.storageManager = storageManager
        
        self.fetchTaskToken = FetchTaskToken(articles: "TopNews", token: Date())
        self.fetchTaskToken = FetchTaskToken(articles: "recomendedNews", token: Date())
        
        self.cache = DiskCache<[ArticleDTO]>(
            filename: "xca_top_news",
            expirationInterval: timeIntervalForUpdateCache
        )
        
        self.selectedCategory = categories.first ?? .top
        
        Task(priority: .high) {
            try? await cache.loadFromDisk()
        }
    }
    
    
    /// Cancels the error alert and refreshes the data.
    func cancelErrorAlert() {
        Task {
            await fetchCategoryNews(ignoreCache: true)
        }
    }
    
    // MARK: - Bookmark Methods
    func toggleBookmark(for article: ArticleDTO) {
        if article.isFavorite {
            deleteBookmark(article)
        } else {
            addBookmark(article)
        }
    }
    
    func updateFavoriteStatus(for article: inout [ArticleDTO]) {
        let bookmarkt = bookmarkManager.fetchBookmarks()
        let bookmarkIDs = Set(bookmarkt.map { $0.id })
        
        for i in article.indices {
            article[i].isFavorite = bookmarkIDs.contains(article[i].id)
        }
    }


    // MARK: - API Methods
    func getCategoryNews() -> [ArticleDTO] { sortedArticles }
    
    func getRecomendedNews() -> [ArticleDTO] { filteredArticles }
    
    /// Refreshes the cache and updates the fetch task token.
    func refreshTask() async {
        await cache.removeValue(forKey: fetchTaskToken.articles)
        fetchTaskToken.token = Date()
    }
    
    // MARK: - Fetch All News
    func fetchCategoryNews(ignoreCache: Bool = false) async {
        categoryNewsPhase = .empty
        do {
            if let cachedArticles = await getCachedArticles(
                for: fetchTaskToken.articles,
                ignoreCache: ignoreCache
            ) {
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
    
    //    MARK: - Recomended News
    func fetchRecomendedNews(ignoreCache: Bool = false) async {
        recomendedNewsPhase = .empty
        
        do {
            if !ignoreCache,
               let cachedArticles = await getCachedArticles(
                for: fetchTaskToken.articles,
                ignoreCache: ignoreCache
               )
            {
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

    // MARK: - Load Categories
    func loadCategories() {
        self.categories = storageManager.loadCategories() ?? []
        if categories.isEmpty {
            categories.append(.health)
        }
    }

    // MARK: - Fetch News with Search
    func fetchSearchResults() {
        Task {
            try await searshNewsResults = newsAPIManager.getSearchedNews(with: searchText)?.results ?? []
        }
    }
    
    // MARK: - Private Methods
    private func getCachedArticles(for key: String, ignoreCache: Bool = false) async -> [ArticleDTO]? {
        if ignoreCache {
            await cache.removeValue(forKey: key)
            return nil
        }
        return await cache.value(forKey: key)
    }
    
    private func fetchCategoryArticlesFromAPI() async throws -> [ArticleDTO] {
        let articles = try await newsAPIManager.getNews(with: country.rawValue, selectedCategory.rawValue)?.results ?? []
        await cache.setValue(articles, forKey: selectedCategory.rawValue)
        try? await cache.saveToDisk()
        return articles
    }
    
    private func fetchAllArticlesFromAPI() async throws -> [ArticleDTO] {
        let allArticles = try await newsAPIManager.getTopNews(with: country.rawValue)?.results ?? []
        await cache.setValue(allArticles, forKey: "recomendedNews")
        try? await cache.saveToDisk()
        return allArticles
    }
    
    
    private func addBookmark(_ article: ArticleDTO) {
        bookmarkManager.saveBookmark(
            id: article.id,
            title: article.title,
            link: article.link ?? "",
            category: article.category?.first ?? "",
            creator: article.creator?.first ?? "",
            descrition: article.description ?? "",
            isFavorite: true,
            userID: ""
        )
    }
    
    private func deleteBookmark(_ article: ArticleDTO) {
        bookmarkManager.deleteBookmark(id: article.id)
    }
}
