//
//  CategoryNewsView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 23.10.2024.
//

import SwiftUI

struct CategoryNewsView: View {
    
    let news: ArticleDTO
    
    var body: some View {
        ZStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.black)
                AsyncImage(url: URL(string:  news.imageUrl ?? ""))
//                    .resizable()
                    .opacity(0.75)
                    .frame(width: 256, height: 256)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button {
                // Add bookmark and save news on savedNews
            }
            label: {
                Image(systemName: "bookmark")
                    .resizable()
                    .frame(width: 18, height: 24)
                    .foregroundStyle(news.isFavorite ? .white : DS.Colors.grayLight)
            }
            .offset(x: 90, y: -90)
            
            VStack(alignment: .leading ) {
                Text(news.category?.first?.uppercased() ?? "")
                    .font(.interRegular(16))
                    .foregroundStyle(DS.Colors.grayLighter)
                Text(news.title)
                    .font(.interSemiBold(16))
                    .frame(width: 208, height: 48, alignment: .leading)
                    .lineLimit(2)
                    .foregroundStyle(Color.white)
                    .offset(y: -10)
                
            }
            .padding(.top,160)
        }
    }
}
