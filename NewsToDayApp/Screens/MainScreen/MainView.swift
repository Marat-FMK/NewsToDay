//
//  MainView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 21.10.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        if viewModel.getSearshResult().isEmpty {
            VStack {
                CustomToolBar(title: Resources.Text.mainTitle, subTitle: Resources.Text.mainSubTitle)
                    .padding(.top, 0)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        SearchBarView()
                        CategoryScrollView()
                        NewsScrollView()
                        RecommendedNewsHeader()
                        RecommendedNewsList()
                    }
                    .padding()
                }
            }
            .onAppear(perform: viewModel.loadCategories)
            .task {
                await viewModel.fetchCategoryNews()
                await viewModel.fetchRecomendedNews()
            }
            .navigationBarHidden(true)
            .background(.background)
            .ignoresSafeArea()
        } else {
            SearchNewsView(
                news: viewModel.getSearshResult(),
                searchText: viewModel.searchText,
                action: viewModel.clearAfterSearch
            )
        }
    }
}

// MARK: - Subviews

extension MainView {
    
    private func SearchBarView() -> some View {
        SearchBar(action: {
            viewModel.fetchSearchResults()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                viewModel.searchText = ""
//            }
        }, text: $viewModel.searchText)
            .padding(.bottom, 16)
    }
    
    private func CategoryScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.categories, id: \.self) { category in
                    CategoryCell(category: category, selected: $viewModel.selectedCategory)
                        .frame(height: 40)
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    private func NewsScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if !viewModel.getCategoryNews().isEmpty {
                    ForEach(viewModel.getCategoryNews()) { article in
                        NavigationLink {
                            DetailView(
                                id: article.id,
                                title: article.title,
                                link: article.link,
                                creator: article.creator,
                                description: article.description,
                                category: article.category,
                                isFavorite: viewModel.bookmarks.contains { $0.id == article.id },
                                imageUrl: article.imageUrl,
                                action: {}
                            )
                        } label: {
                            CategoryNewsCell(
                                id: article.id,
                                title: article.title,
                                imageUrl: article.imageUrl,
                                isFavorite: viewModel.bookmarks.contains { $0.id == article.id },
                                category: article.category,
                                action: {
                                    viewModel.toggleBookmark(for: article)
                                }
                            )
                            
                            .frame(height: 256)
                        }
                    }
                    .redacted(reason: viewModel.getCategoryNews().isEmpty
                              ? .placeholder :
                                []
                    )
                } else {
                    ForEach(0..<5) { _ in
                        ShimmerView(cef: 1)
                    }
                }
            }
            .padding(.bottom, 50)
        }
    }
    
    private func RecommendedNewsHeader() -> some View {
        HStack {
            Text(Resources.Text.recommendedForYou)
                .font(.interSemiBold(20))
                .frame(width: 240, height: 24)
                .foregroundStyle(DS.Colors.blackyPrimary)
            
            Spacer()
            
            NavigationLink {
                AllRecomendedNewsView(news: viewModel.getRecomendedNews())
            } label: {
                    Text("See All")
                        .font(.interRegular(14))
                        .foregroundStyle(DS.Colors.grayPrimary)
            }
        }
        .padding(.bottom, 30)
    }
    
    private func RecommendedNewsList() -> some View {
        Group {
            if viewModel.getRecomendedNews().isEmpty {
                ForEach(1..<5) { _ in
                    VStack {
                        HStack {
                            ShimmerView(cef: 2.56)
                            ShimmerTextView()
                        }
                    }
                }
            } else {
                ForEach(viewModel.getRecomendedNews()) { article in
                    NavigationLink {
                        DetailView(
                            id: article.id,
                            title: article.title,
                            link: article.link,
                            creator: article.creator,
                            description: article.description,
                            category: article.category,
                            isFavorite: viewModel.bookmarks.contains { $0.id == article.id },
                            imageUrl: article.imageUrl,
                            action: {
                                viewModel.toggleBookmark(for: article)
                            }
                        )
                    } label: {
                        RecommendedNewsView(
                            title: article.title,
                            imageUrl: article.imageUrl,
                            category: article.category
                        )
                        .frame(height: 96)
                    }
                }
                .padding(.bottom, 16)
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(viewModel: MainViewModel(newsAPIManager: NewsAPIManager()))
        }
    }
}
