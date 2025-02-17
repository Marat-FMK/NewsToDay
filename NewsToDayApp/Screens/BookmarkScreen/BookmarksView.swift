////
////  FavoritesView.swift
////  NewsToDayApp
////
////  Created by Evgeniy on 20.10.2024.
////

import SwiftUI

struct BookmarkView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    @StateObject private var viewModel = BookmarksViewModel()

    // MARK: - Drawing Constants

    private enum Drawing {
        static let circleSize: CGFloat = 72
        static let iconSize: CGFloat = 24
        static let verticalPadding: CGFloat = 10
        static let articleHeight: CGFloat = 96
    }
    
    var body: some View {
        VStack {
            ZStack {
                setupToolbar()
                Button {
                    viewModel.deleteAllBookmarks()
                } label: {
                    Text("Delete All".localized(language))
                }
                .offset(x: 130, y: 30)
            }
            Spacer()
            if viewModel.bookmarks.isEmpty {
                emptyStateView()
                
            } else {
                bookmarksListView()
            }
            Spacer()
        }
        .padding(.bottom,110)
        .onAppear(perform: viewModel.fetchBookmarks)
        .navigationBarHidden(true)
        .background(Color.newsBackground)
        .ignoresSafeArea()
    }
}

// MARK: - Subviews

extension BookmarkView {
    
    // MARK: Toolbar
    private func setupToolbar() -> some View {
        CustomToolBar(
            title: Resources.Text.bookmarksTitle.localized(language),
            subTitle: Resources.Text.bookmarksSubTitle.localized(language)
        )
        .padding(.top, 0)
    }
    
    // MARK: Empty State View
    private func emptyStateView() -> some View {
        VStack {
            ZStack {
                Circle()
                    .fill(DS.Colors.purpleLighter)
                    .frame(width: Drawing.circleSize, height: Drawing.circleSize)
                
                Image(systemName: "text.book.closed")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Drawing.iconSize, height: Drawing.iconSize)
                    .foregroundStyle(.newsText)
                
            }
            Text("You haven't saved any articles yet. Start reading and bookmarking them now".localized(language))
                .multilineTextAlignment(.center)
                .foregroundStyle(.newsText)
                .font(.interSemiBold(16))
                .padding(.horizontal, 30)

        }
        .background(.newsBackground)
    }
    
    // MARK: Bookmarks List View
    private func bookmarksListView() -> some View {
        List {
            ForEach(Array(viewModel.bookmarks)) { article in
                bookmarkNavigationLink(for: article)
            }
            .onDelete(perform: deleteBookmark)
            .listRowBackground(Color.newsBackground)
        }
        .listStyle(PlainListStyle())
     
    }
    
    // MARK: Bookmark Deletion
    private func deleteBookmark(at offsets: IndexSet) {
        let bookmarksArray = Array(viewModel.bookmarks)
        
        for index in offsets {
            let article = bookmarksArray[index]
            viewModel.deleteBookmark(withId: article.id)
        }
    }
    
    // MARK: Navigation Link for Each Bookmark
    private func bookmarkNavigationLink(for article: ArticleDTO) -> some View {
        NavigationLink(destination: DetailView(article)) {
            ArticleView(model: article)
                .padding(.vertical, Drawing.verticalPadding)
                .frame(height: Drawing.articleHeight)
        }
    }
}


