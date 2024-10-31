//
//  CustomTextField.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

struct CustomTextField: View {
    var image: String
    var placeHolder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool // Следит за фокусом текстового поля
    
    var body: some View {
        HStack(spacing: 24) { // Отступ между иконкой и текстом
            Image(systemName: image)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(isFocused ? DS.Colors.grayPrimary : DS.Colors.purplePrimary) // Цвет иконки, можно заменить
            
            ZStack {
                if placeHolder == "Password" || placeHolder == "Repeat Password"{
                    SecureField(placeHolder, text: $text)
                } else {
                    TextField(placeHolder, text: $text)
                        .font(.system(size: 16, weight: .medium))
                        .frame(height: 56)
                }
            }
        }
        .padding(.horizontal, 16) // Внутренние отступы
        .frame(width: 336, height: 56) // Размер текстового поля
        .background(isFocused ? DS.Colors.grayLighter : Color.white) // Цвет фона при фокусе
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? DS.Colors.grayLighter : DS.Colors.purplePrimary, lineWidth: 1) // Цвет и толщина границы
        )
    }
    
}


struct TextF_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(image: "person", placeHolder: "Username", text: .constant("Demo text"))
    }
}
