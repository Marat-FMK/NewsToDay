////
////  FavoritesView.swift
////  NewsToDayApp
////
////  Created by Evgeniy on 20.10.2024.
////

import SwiftUI

struct BookmarkView: View {
    @StateObject private var viewModel = BookmarksViewModel()

    var body: some View {
        VStack {
            setupToolbar()
            Spacer()
            if viewModel.bookmarks.isEmpty {
                emptyStateView()
            } else {
                bookmarksListView()
            }
            Spacer()
        }
        .onAppear(perform: viewModel.fetchBookmarks)
        .navigationBarHidden(true)
//        .background(Color.background)
        .ignoresSafeArea()
    }
}

// MARK: - Subviews

extension BookmarkView {
    
    private func setupToolbar() -> some View {
        CustomToolBar(
            title: Resources.Text.bookmarksTitile,
            subTitle: Resources.Text.bookmarksSubTitle
        )
        .padding(.top, 0)
    }
    
    private func emptyStateView() -> some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 72, height: 72)
                
                Image(systemName: "text.book.closed")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
      
        }
    }
    
    private func bookmarksListView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack {
                ForEach(viewModel.bookmarks, id: \.id)  { article in
                    bookmarkNavigationLink(for: article)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func bookmarkNavigationLink(for article: ArticleDTO) -> some View {
        NavigationLink(destination: DetailView(
            id: article.id,
            title: article.title,
            link: article.link,
            creator: article.creator,
            description: article.description,
            category: article.category,
            isFavorite: article.isFavorite,
            imageUrl: article.imageUrl,
            action: {}
        )) {
            ArticleView(model: article)
                .padding(.vertical, 10)
                .swipeActions {
                    deleteButton(for: article.id)
                }
        }
    }
    
    private func deleteButton(for articleId: String) -> some View {
        Button(action: {
            viewModel.deleteBookmark(withId: articleId)
        }) {
            Text("Delete")
        }
        .tint(.red)
    }
}
