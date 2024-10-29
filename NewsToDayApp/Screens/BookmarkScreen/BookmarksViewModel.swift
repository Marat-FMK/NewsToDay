//
//  FavoritesViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

@MainActor
final class BookmarksViewModel: ObservableObject {
    @Published var bookmarks: [ArticleDTO] = []
    
    private var boormarksManager: IBookMarks
    
    init(boormarksManager: IBookMarks = BookMarksManager.shared) {
        self.boormarksManager = boormarksManager
    }
    
    func fetchBookmarks() {
        Task {
            let bookmarkEntities = boormarksManager.fetchBookmarks()
            print(bookmarkEntities)
            self.bookmarks = bookmarkEntities.map { ArticleDTO(from: $0) }
        }
    }
    
    func deleteBookmark(withId id: String) {
        boormarksManager.deleteBookmark(id: id)
        fetchBookmarks()
    }
    
    func deleteAllBookmarks() {
        boormarksManager.deleteAllBookmarks()
    }
}
