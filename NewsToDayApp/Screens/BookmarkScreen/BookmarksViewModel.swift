//
//  FavoritesViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

/// ViewModel for managing bookmarked news articles.
@MainActor
final class BookmarksViewModel: ObservableObject {
    /// Published property to store a set of bookmarks.
    @Published var bookmarks: Set<ArticleDTO> = []
  
    private var bookmarkManager: IBookMarks
    
    // MARK: - Initializer
    
    /// Initializer that allows dependency injection of `IBookMarks`.
    /// - Parameter bookmarkManager: Bookmark manager, default is `BookMarksManager.shared`.
    init(bookmarkManager: IBookMarks = BookMarksManager.shared) {
        self.bookmarkManager = bookmarkManager
    }
    
    // MARK: - Bookmark Fetching
    
    /// Fetches bookmarks from the bookmark manager and updates the `bookmarks` set.
    func fetchBookmarks() {
        Task {
            let bookmarkEntities = bookmarkManager.fetchBookmarks()
            self.bookmarks = Set(bookmarkEntities.map { ArticleDTO(from: $0) })
        }
    }
    
    // MARK: - Bookmark Deletion
    
    /// Deletes a specific bookmark by its `id`.
    /// - Parameter id: The identifier of the article to delete from bookmarks.
    func deleteBookmark(withId id: String) {
        if let article = bookmarks.first(where: { $0.id == id }) {
            bookmarks.remove(article)
            bookmarkManager.deleteBookmark(id: id)
        }
    }
    
    /// Deletes all bookmarks from the storage.
    func deleteAllBookmarks() {
        bookmarkManager.deleteAllBookmarks()
        bookmarks.removeAll()
    }
}
