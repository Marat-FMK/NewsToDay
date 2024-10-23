//
//  HeaderTitleView.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 23.10.2024.
//

import SwiftUI

struct TitleHeaderView: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            // Заголовок
            Text(title)
                .font(.custom("Inter", size: 24)) // Шрифт Inter, размер 24
                .fontWeight(.semibold) // Вес шрифта 600
                .foregroundColor(Color(.black)) // Используем кастомный цвет
                .lineSpacing(32 - 24) // Высота строки 32px
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.init(top: 28, leading: .zero, bottom: 8, trailing: .zero))
            
            // Подзаголовок
            Text(subtitle)
                .font(.custom("Inter", size: 16)) // Шрифт Inter, размер 16
                .fontWeight(.regular) // Вес шрифта 400
                .foregroundColor(Color(.gray)) // Используем кастомный цвет
                .lineSpacing(24 - 16) // Высота строки 24px
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.init(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
        }
    }
}
