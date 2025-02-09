//
//  CategoryNewsCell.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 23.10.2024.
//

import SwiftUI

struct CategoryNewsCell: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    let id: String
    let title: String
    let imageUrl: String?
    let isFavorite: Bool
    let category: [String]?
    let action: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.black)
            
            AsyncCachedImage(url: URL(string: imageUrl ?? ""))
            .opacity(0.75)
            .frame(width: 256, height: 256)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        
        Button {
            action()
        } label: {
            Image(systemName: "bookmark")
                .resizable()
                .frame(width: 18, height: 24)
                .foregroundStyle(isFavorite ? .red : DS.Colors.grayLight)
        }
        .offset(x: 90, y: -90)
        
        // Тексты и категории
        VStack(alignment: .leading ) {
            Text(category?.first?.localized(language).uppercased() ?? "")
                .font(.interRegular(16))
                .foregroundStyle(DS.Colors.grayLighter)
            Text(title.localized(language))
                .font(.interSemiBold(16))
                .frame(width: 208, height: 48, alignment: .leading)
                .lineLimit(2)
                .foregroundStyle(Color.white)
                .offset(y: -10)
        }
        .padding(.top, 160)
    }
    }
}
