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
        VStack {
            CustomToolBar(
                title: Resources.Text.mainTitle,
                subTitle: Resources.Text.mainSubTitle
            )
            .padding(.top, 0)
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    
                    SearchBar(text: $viewModel.searchText)
                        .padding(.bottom, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.categories, id: \.self) { category in
                                CategoryCell(
                                    category: category,
                                    selected: $viewModel.selectedCategory
                                )
                            }
                        }
                        .padding(.bottom,20)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
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
                                }
                            }
                        }
                    }
                    .padding(.bottom,50)
                    
                    HStack {
                        Text("Recommended for you")
                            .font(.interSemiBold(20))
                            .frame(width: 240, height: 24)
                            .foregroundStyle(DS.Colors.blackyPrimary)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await viewModel.refreshTask()
                            }
                        } label: {
                            Text("See All")
                                .font(.interRegular(14))
                                .foregroundStyle(DS.Colors.grayPrimary)
                        }
                    }
                    .padding(.bottom,30)
                    
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
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear{
            viewModel.loadCategories()
        }
        .task {
            await viewModel.fetchCategoryNews()
            await viewModel.fetchRecomendedNews()
        }
        .navigationBarHidden(true)
        .background(.background)
        .ignoresSafeArea()
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(viewModel: MainViewModel(newsAPIManager: NewsAPIManager()))
        }
    }
}
