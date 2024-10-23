//
//  RecommendedNewsView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 23.10.2024.
//

import SwiftUI

struct RecommendedNewsView: View {
    let news: ArticleDTO
    
    var body: some View {
        HStack {
            
            ZStack {
                
//                RoundedRectangle(cornerRadius: 12) // Раскоментить , если надо затемнить рекоменд тоже
//                    .foregroundStyle(.black)
//                    .frame(width: 96, height: 96)
                AsyncImage(url: URL(string:  news.imageUrl ?? ""))
//                    .resizable()
//                    .opacity(0.75)
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
            }
            VStack(alignment: .leading) {
                Text(news.category?.first ?? "")
                    .frame(width:224, height: 20, alignment: .leading)
                    .font(.interMedium(14))
                    .foregroundStyle(DS.Colors.grayPrimary)
                
                Text(news.title)
                    .frame(width: 223, height: 48, alignment: .leading)
                    .font(.interSemiBold(16))
                    .foregroundStyle(DS.Colors.blackyPrimary)
                    .lineLimit(2)
            }
            .padding(.leading,16)
        }
    }
}
