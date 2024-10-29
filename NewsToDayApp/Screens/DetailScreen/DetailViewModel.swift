//
//  DetailViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

final class DetailViewModel: ObservableObject {
    
    let detailArticle: ArticleDTO
    
    @Published var bookmarks: [ArticleDTO] = []
    @Published var isBookmarked: Bool = false
    
    private let bookmarkManager: BookMarksManager
    
    // MARK: - Init
    init(detailArticle: ArticleDTO, bookmarkManager: BookMarksManager = .shared) {
        self.detailArticle = detailArticle
        self.bookmarkManager = bookmarkManager
        
        fetchBookmarks()
    }
    
    // MARK: - Bookmark Methods
    private func fetchBookmarks() {
         let bookmarkList = bookmarkManager.fetchBookmarks()
         self.bookmarks = bookmarkList.map { ArticleDTO(from: $0)}
        
        self.isBookmarked = bookmarks.contains(where: { $0.id == detailArticle.id })
     }
    
    func toggleBookmark() {
            if isBookmarked {
                deleteBookmark(detailArticle)
            } else {
                addBookmark(detailArticle)
            }
            isBookmarked.toggle()
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
        fetchBookmarks()
    }
    
    private func deleteBookmark(_ article: ArticleDTO) {
        bookmarkManager.deleteBookmark(id: article.id)
        fetchBookmarks()
    }
}
