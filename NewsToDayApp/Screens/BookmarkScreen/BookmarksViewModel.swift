//
//  FavoritesViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

@MainActor
final class BookmarksViewModel: ObservableObject {
    @Published var bookmarks: Set<ArticleDTO> = []
  
    private var bookmarkManager: IBookMarks
    
    init(bookmarkManager: IBookMarks = BookMarksManager.shared) {
        self.bookmarkManager = bookmarkManager
    }
    
    func fetchBookmarks() {
        Task {
            let bookmarkEntities = bookmarkManager.fetchBookmarks()
            self.bookmarks = Set(bookmarkEntities.map { ArticleDTO(from: $0)})
        }
    }
    
    func deleteBookmark(withId id: String) {
        if let article = bookmarks.first(where: { $0.id == id }) {
            bookmarks.remove(article)
            bookmarkManager.deleteBookmark(id: id)
        }
    }
    
    func deleteAllBookmarks() {
        bookmarkManager.deleteAllBookmarks()
    }
}
