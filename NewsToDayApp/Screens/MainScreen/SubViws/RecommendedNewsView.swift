//
//  RecommendedNewsView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 23.10.2024.
//

import SwiftUI

struct RecommendedNewsView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    let title: String
    let imageUrl: String?
    let category: [String]?
    
    var body: some View {
        HStack {
            ZStack {
                AsyncCachedImage(url: URL(string: imageUrl ?? ""))
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            VStack(alignment: .leading) {
                Text(category?.first?.localized(language) ?? "")
                    .frame(width:224, height: 20, alignment: .leading)
                    .font(.interMedium(14))
                    .foregroundStyle(DS.Colors.grayPrimary)
                
                Text(title.localized(language))
                    .frame(width: 223, height: 48, alignment: .leading)
                    .font(.interSemiBold(16))
                    .foregroundStyle(Color.newsText)
                    .lineLimit(2)
            }
            .padding(.leading,16)
        }
        .background(.newsBackground)
    }
}
