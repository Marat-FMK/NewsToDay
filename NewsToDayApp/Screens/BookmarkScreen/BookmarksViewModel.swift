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
        let bookmarkEntities = boormarksManager.fetchBookmarks()
        self.bookmarks = bookmarkEntities.map { entity in
            ArticleDTO(from: entity)
        }
    }
    
    func deleteBookmark(withId id: String) {
        boormarksManager.deleteBookmark(id: id)
        fetchBookmarks()
    }
    
}
