//
//  SearchNewsView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 27.10.2024.
//

import SwiftUI

struct SearchNewsView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    @Environment(\.dismiss) var dismiss
    
    let news: [ArticleDTO]
    let searchText: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomToolBar(
                title: Resources.Text.searchedNews.localized(language),
                subTitle: Resources.Text.search.localized(language) + ": \(searchText)"
            )
                    .padding(.bottom,10)
                    .padding(.top,30)
            
            ScrollView(showsIndicators: false) {
                ForEach(news) { news in
                    NavigationLink{
                        DetailView(news)
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
        
        .toolbar {
            ToolbarItem( placement: .topBarLeading) {
                Button {
                    action()
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
