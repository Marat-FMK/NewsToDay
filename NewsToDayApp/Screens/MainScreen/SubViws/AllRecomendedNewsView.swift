//
//  AllRecomendedNewsView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 27.10.2024.
//

import SwiftUI

struct AllRecomendedNewsView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    @Environment(\.dismiss) var dismiss
    let news: [ArticleDTO]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            CustomToolBar(title: Resources.Text.allRecommendedNews.localized(language), subTitle: Resources.Text.weHaveSelectedTheBestNewsForYou.localized(language))
                    .padding(.bottom,10)
                    .padding(.top,30)
            
            ScrollView(showsIndicators: false) {
            if news.isEmpty {
                ForEach(1..<9) { _ in
                    VStack {
                        HStack {
                            ShimmerView(cef: 2.56)
                            ShimmerTextView()
                        }
                    }
                }
            } else {
                VStack {
                    ForEach(news) { article in
                        NavigationLink {
                            DetailView(article)
                        } label: {
                            RecommendedNewsView(
                                title: article.title,
                                imageUrl: article.imageUrl,
                                category: article.category
                            )
                        }
                    }
                }
                .padding(.bottom,110)
            }
        }
                .padding()
    }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem( placement: .topBarLeading) {
                Button{
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
//    AllRecomendedNewsView()
//}
