//
//  SearchBar.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 23.10.2024.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    
    private struct Drawing {
        static let iconPadding: CGFloat = 12
        static let iconName: String = "magnifyingglass"
        static let textFieldHeight: CGFloat = 55
        static let backgroundColorOpacity: Double = 0.2
        static let cornerRadius: CGFloat = 12
    }

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: Drawing.iconName)
                .foregroundColor(DS.Colors.grayLight)
                .padding(Drawing.iconPadding)
            TextField(Resources.Text.search, text: $text)
                .foregroundStyle(DS.Colors.grayDark)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }, label: {
                    Image(systemName: "xmark")
                })
                .foregroundColor(DS.Colors.grayLight)
                .padding(Drawing.iconPadding)
            }
        }
        .frame(height: Drawing.textFieldHeight)
        .frame(maxWidth: .infinity)
        .background(DS.Colors.grayLighter)
        .cornerRadius(Drawing.cornerRadius)

    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("search"))
    }
}


