//
//  SearchNewsView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 27.10.2024.
//

import SwiftUI

struct SearchNewsView: View {
    @Environment(\.dismiss) var dismiss
    
    let news: [ArticleDTO]
    let searchText: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomToolBar(
                title: Resources.Text.searchedNews,
                subTitle: Resources.Text.search + ": \(searchText)"
            )
                    .padding(.bottom,10)
                    .padding(.top,30)
            
            ScrollView(showsIndicators: false) {
                ForEach(news) { news in
                    NavigationLink{
                        DetailView(
                            id: news.id,
                            title: news.title,
                            link: news.link,
                            creator: news.creator,
                            description: news.description,
                            category: news.category,
                            isFavorite: true,
                            imageUrl: news.imageUrl,
                            action: {}
                        )
                    } label: {
                        RecommendedNewsView(
                            title: news.title,
                            imageUrl: news.imageUrl,
                            category: news.category
                        )
                    }
                }
        }
                .padding()
    }
        .padding(.bottom, 100)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .onDisappear {
            action()
        }
        
        .toolbar {
            ToolbarItem( placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Resources.Image.arrowLeft)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

//#Preview {
//    SearchNewsView()
//}
