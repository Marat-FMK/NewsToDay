//
//  MainView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 21.10.2024.
//

import SwiftUI


struct MainView: View {
    @StateObject var viewModel: MainViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
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
    }
}

// MARK: - Subviews

extension MainView {
    
    private func SearchBarView() -> some View {
        SearchBar(text: $viewModel.searchText)
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
                                isFavorite: article.isFavorite,
                                imageUrl: article.imageUrl,
                                action: {}
                            )
                        } label: {
                            CategoryNewsCell(
                                id: article.id,
                                title: article.title,
                                imageUrl: article.imageUrl,
                                isFavorite: article.isFavorite,
                                category: article.category,
                                action: {}
                            )
                            
                            .frame(height: 256)
                        }
                    }
                    .redacted(reason: viewModel.getCategoryNews().isEmpty
                              ? .placeholder :
                                []
                    )
                } else {
                    ShimmerView()
                }
            }
            .padding(.bottom, 50)
        }
    }
    
    private func RecommendedNewsHeader() -> some View {
        HStack {
            Text("Recommended for you")
                .font(.interSemiBold(20))
                .frame(width: 240, height: 24)
                .foregroundStyle(DS.Colors.blackyPrimary)
            
            Spacer()
            
            Button {
                Task { await viewModel.refreshTask() }
            } label: {
                Text("See All")
                    .font(.interRegular(14))
                    .foregroundStyle(DS.Colors.grayPrimary)
            }
        }
        .padding(.bottom, 30)
    }
    
    private func RecommendedNewsList() -> some View {
        ForEach(viewModel.getRecomendedNews()) { article in
            NavigationLink {
                DetailView(
                    id: article.id,
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
        .redacted(reason: viewModel.getRecomendedNews().isEmpty
                  ? .placeholder
                  : []
        )
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(viewModel: MainViewModel(newsAPIManager: NewsAPIManager()))
        }
    }
}
