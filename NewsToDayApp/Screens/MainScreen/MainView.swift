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
        if viewModel.searshNewsResults.isEmpty {
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
            SearchNewsView(news: $viewModel.searshNewsResults, searchText: $viewModel.searchText)
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
                    ForEach(viewModel.getCategoryNews()) { news in
                        NavigationLink {
                            DetailView(
                                title: news.title,
                                link: news.link,
                                creator: news.creator,
                                description: news.description,
                                category: news.category,
                                isFavorite: news.isFavorite,
                                imageUrl: news.imageUrl,
                                action: {}
                            )
                        } label: {
                            CategoryNewsCell(
                                title: news.title,
                                imageUrl: news.imageUrl,
                                isFavorite: news.isFavorite,
                                category: news.category
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
                            title: article.title,
                            link: article.link,
                            creator: article.creator,
                            description: article.description,
                            category: article.category,
                            isFavorite: article.isFavorite,
                            imageUrl: article.imageUrl,
                            action: {}
                        )
                    } label: {
                        RecommendedNewsView(
                            title: article.title,
                            imageUrl: article.imageUrl,
                            category: article.category
                        )
                        .frame(height: 100)
                    }
                }
                .padding(.bottom,150)
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
