//
//  CategoryCell.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 24.10.2024.
//

import SwiftUI

struct CategoryCell: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    
    // MARK: - Constants
    private enum Drawing {
        static let verticalPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let selectedCornerRadius: CGFloat = 25.0
    }
    
    // MARK: - Properties
    let category: Categories
    @Binding var selected: Categories
    @Namespace private var namespace
    
    // MARK: - Body
    var body: some View {
        Text(category.rawValue.localized(language))
            .foregroundStyle(foregroundColor(for: category))
            .padding(.vertical, Drawing.verticalPadding)
            .padding(.horizontal, Drawing.horizontalPadding)
            .background(background(for: category))
            .cornerRadius(Drawing.cornerRadius)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    selected = category
                }
            }
    }
    
    // MARK: - View Helpers
    @ViewBuilder
    private func background(for category: Categories) -> some View {
        if selected == category {
            RoundedRectangle(cornerRadius: Drawing.selectedCornerRadius)
                .fill(DS.Colors.purplePrimary)
                .matchedGeometryEffect(id: "categoryBackground", in: namespace)
        } else {
            RoundedRectangle(cornerRadius: Drawing.selectedCornerRadius)
                .fill(Color.buttonBackground)
                .matchedGeometryEffect(id: "categoryBackground", in: namespace)
        }
    }
    
    private func foregroundColor(for category: Categories) -> Color {
        selected == category ? DS.Colors.purpleLighter : Color.newsSystemBackground
    }
}
