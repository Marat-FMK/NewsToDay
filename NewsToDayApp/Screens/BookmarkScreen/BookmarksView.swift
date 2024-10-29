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
                .overlay {
                    Button {
                        viewModel.deleteAllBookmarks()
                    } label: {
                        Text("delete all")
                    }
                }
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
                    .fill(DS.Colors.purpleLighter)
                    .frame(width: 72, height: 72)
                
                Image(systemName: "text.book.closed")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
      
        }
    }
    
    private func bookmarksListView() -> some View {
        List {
            ForEach(viewModel.bookmarks) { article in
                bookmarkNavigationLink(for: article)
            }
            .onDelete(perform: deleteBookmark)
        }
        .listStyle(PlainListStyle())
        
    }
    
    private func deleteBookmark(at offsets: IndexSet) {
           for index in offsets {
               let articleId = viewModel.bookmarks[index].id
               viewModel.deleteBookmark(withId: articleId)
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
                .frame(height: 96)
        }
    }
}
