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

@MainActor
final class MainViewModel: ObservableObject {
    @Published var categoryNewsPhase: DataFetchPhase<[ArticleDTO]> = .empty
    @Published var recomendedNewsPhase: DataFetchPhase<[ArticleDTO]> = .empty
    @Published var searshNewsResultsPhase: DataFetchPhase<[ArticleDTO]> = .empty
    
    @Published var bookmarks: [ArticleDTO] = []
    @Published var isBookmarked: Bool = false
    
    @Published var fetchTaskToken: FetchTaskToken
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    @Published var categories: [Categories] = []
    
    @Published var selectedCategory: Categories = .top {
        didSet {
            Task {
                print(selectedCategory)
                await fetchCategoryNews(ignoreCache: true)
            }
        }
    }
    
    private let newsAPIManager: INewsAPIManager
    private let bookmarkManager: IBookMarks
    private let storageManager: IUserDefaultManager
    
    private let timeIntervalForUpdateCache: TimeInterval = 7 * 24 * 60 * 60
    private let cache: DiskCache<[ArticleDTO]>
    private let countries: [Country] = [.gb, .us, .ru, .fr, .cn]
    

    
    // MARK: - Computed Properties
    private var filteredArticles: [ArticleDTO] {
        guard let articles = recomendedNewsPhase.value else { return [] }
        
        return articles
    }
    
    var error: Error? {
        if case let .failure(error) = categoryNewsPhase {
            return error
        }
        return nil
    }
    
    // MARK: - Initializer with Dependency Injection
    init(_ newsAPIManager: INewsAPIManager,
         bookmardManager: IBookMarks = BookMarksManager.shared,
         storageManager: IUserDefaultManager = StorageManager.shared
    ) {
        self.newsAPIManager = newsAPIManager
        self.bookmarkManager = bookmardManager
        self.storageManager = storageManager
        
        self.fetchTaskToken = FetchTaskToken(articles: "TopNews", token: Date())
        self.fetchTaskToken = FetchTaskToken(articles: "recomendedNews", token: Date())
        
        self.cache = DiskCache<[ArticleDTO]>(
            filename: "xca_top_new",
            expirationInterval: timeIntervalForUpdateCache
        )
        
        Task(priority: .high) {
            try? await cache.loadFromDisk()
        }
        fetchBookmarks()
    }
    
    /// Cancels the error alert and refreshes the data.
    func cancelErrorAlert() {
        Task {
            await fetchCategoryNews(ignoreCache: true)
        }
    }
    
    // MARK: - Bookmark Methods
    private func fetchBookmarks() {
         let bookmarkList = bookmarkManager.fetchBookmarks()
         self.bookmarks = bookmarkList.map { ArticleDTO(from: $0)}
     }
    
    func toggleBookmark(for article: ArticleDTO) {
        if bookmarks.contains(article) {
            deleteBookmark(article)
        } else {
            addBookmark(article)
        }
        objectWillChange.send()
    }
    
    // MARK: - API Methods
    func getCategoryNews() -> [ArticleDTO] { categoryNewsPhase.value ?? [] }
    
    func getRecomendedNews() -> [ArticleDTO] { filteredArticles }
    func getSearshResult() -> [ArticleDTO] { searshNewsResultsPhase.value ?? [] }
    
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
            let searshNewsResults = try await newsAPIManager.getSearchedNews(with: searchText)?.results ?? []
            searshNewsResultsPhase = .success(searshNewsResults)
        }
    }
    
    func clearAfterSearch() {
        searshNewsResultsPhase = .empty
        searchText = ""
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
        let countriesString = countries.map { $0.rawValue }.joined(separator: ",")
        let articles = try await newsAPIManager.getNews(with: countriesString, selectedCategory.rawValue)?.results ?? []
        await cache.setValue(articles, forKey: selectedCategory.rawValue)
        try? await cache.saveToDisk()
        return articles
    }
    
    private func fetchAllArticlesFromAPI() async throws -> [ArticleDTO] {
        let countriesString = countries.map { $0.rawValue }.joined(separator: ",")
        let allArticles = try await newsAPIManager.getTopNews(with: countriesString)?.results ?? []
        await cache.setValue(allArticles, forKey: "recomendedNews")
        try? await cache.saveToDisk()
        return allArticles
    }
    
    private func addBookmark(_ article: ArticleDTO) {
        bookmarkManager.saveBookmark(
            id: article.id,
            title: article.title,
            link: article.link ?? "",
            imageURL: article.imageUrl ?? "" ,
            category: article.category?.first ?? "",
            creator: article.creator?.first ?? "",
            descrition: article.description ?? "",
            userID: ""
        )
        bookmarks.append(article)
    }
    
    private func deleteBookmark(_ article: ArticleDTO) {
        bookmarkManager.deleteBookmark(id: article.id)
        bookmarks.removeAll { $0.id == article.id }
    }
}
