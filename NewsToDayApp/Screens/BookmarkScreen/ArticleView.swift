//
//  ArticleView.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 23.10.2024.
//

import SwiftUI

// MARK: - ArticleView
struct ArticleView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    // MARK: - Properties
    let model: ArticleDTO
       
    // MARK: - Body
    var body: some View {
        HStack {
            // MARK: - Image View
            AsyncCachedImage(url: URL(string: model.imageUrl ?? ""))
            .frame(width: Drawing.imageSize, height: Drawing.imageSize)
            .clipShape(RoundedRectangle(cornerRadius: Drawing.cornerRadius))
        
            // MARK: - Text Content
            VStack(alignment: .leading) {
                Text(model.category?.first?.capitalized.localized(language) ?? "")
                    .font(.interMedium(Drawing.titleFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Color.newsText)
                    .lineSpacing(Drawing.titleLineSpacing)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, Drawing.titleVerticalPadding)
                
                Text(model.title.localized(language))
                    .font(.system(size: Drawing.categoryFontSize, weight: .semibold))
                    .foregroundColor(Color.newsSystemBackground)
                    .lineSpacing(Drawing.categoryLineSpacing)
                    .frame(height: Drawing.categoryFrameHeight, alignment: .top)
                    .padding(.bottom, Drawing.categoryBottomPadding)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, Drawing.textPaddingLeading)
            .background(.newsBackground)
        }
    }
}

// MARK: - Drawing Constants

private enum Drawing {
    static let imageSize: CGFloat = 96
    static let cornerRadius: CGFloat = 12
    static let titleFontSize: CGFloat = 14
    static let titleLineSpacing: CGFloat = 6
    static let titleVerticalPadding: CGFloat = 8
    static let categoryFontSize: CGFloat = 16
    static let categoryLineSpacing: CGFloat = 8
    static let categoryFrameHeight: CGFloat = 50
    static let categoryBottomPadding: CGFloat = 8
    static let textPaddingLeading: CGFloat = 16
}
