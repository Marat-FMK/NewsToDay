//
//  ArticleView.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 23.10.2024.
//

import SwiftUI

struct ArticleView: View {
    
    let model: News
       
       var body: some View {
           HStack() {
               // Используем встроенное изображение
               model.image
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .frame(width: 96, height: 96)
                   .background(Color.black.opacity(0.4)) // Захардкоженный цвет фона
                   .clipShape(RoundedRectangle(cornerRadius: 12)) // Закругляем углы
               
               VStack(alignment: .leading) {
                   Text(model.name)
                       .font(.custom("Inter", size: 14)) // Шрифт Inter, размер 14
                       .fontWeight(.semibold) // Вес шрифта 600
                       .foregroundColor(Color(.black)) // Используем кастомный цвет
                       .lineSpacing(20 - 14)
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .padding(.vertical, 8)
//                       .background(Color.yellow.opacity(0.1))

                   
                   Text(model.category)
                       .font(.system(size: 16, weight: .semibold))
                       .foregroundColor(Color(.black)) // Используем кастомный цвет
                       .lineSpacing(24 - 16)
                       .frame(height: 50, alignment: .top)
                       .padding(.bottom, 8)
                       .lineLimit(2)
//                       .background(Color.red.opacity(0.1))
        
               }
               .frame(maxWidth: .infinity)
               .padding(.init(top: .zero, leading: 16, bottom: .zero, trailing: .zero)) // Захардкоженные отступы для VStack
           }
       }
}
