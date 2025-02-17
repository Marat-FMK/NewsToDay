//
//  MainView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 21.10.2024.
//

import SwiftUI

struct MainView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    
    @StateObject var viewModel: MainViewModel
    
    // MARK: - Initializer
    init(_ newsAPIManager: INewsAPIManager) {
        self._viewModel = StateObject(
            wrappedValue: MainViewModel(newsAPIManager)
        )
    }
    
    var body: some View {
        if viewModel.getSearshResult().isEmpty {
            VStack {
                CustomToolBar(title: Resources.Text.mainTitle.localized(language),
                              subTitle: Resources.Text.mainSubTitle.localized(language))
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
                await viewModel.fetchCategoryNews(ignoreCache: true)
                await viewModel.fetchRecomendedNews(ignoreCache: true)
            }
            .navigationBarHidden(true)
            .background(.newsBackground)
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
        }, text: $viewModel.searchText)
            .padding(.bottom, 16)
    }
    
    private func CategoryScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.categories, id: \.self) { category in
                    CategoryCell(
                        category: category,
                        selected: $viewModel.selectedCategory
                    )
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
                            DetailView(article)
                            
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
            Text(Resources.Text.recommendedForYou.localized(language))
                .font(.interSemiBold(20))
                .frame(width: 240, height: 24, alignment: .leading)
                .foregroundStyle(Color.newsText)
            
            Spacer()
            
            NavigationLink {
                AllRecomendedNewsView(news: viewModel.getRecomendedNews())
            } label: {
                Text(Resources.Text.seeAll.localized(language))
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
                VStack{
                ForEach(viewModel.getRecomendedNews()) { article in
                    NavigationLink {
                        DetailView(article)
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
                .padding(.bottom,110)
            }
        }
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(NewsAPIManager())
        }
    }
}
