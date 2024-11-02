//
//  SettingsHeaderView.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

enum TitleType {
    case withBackButton
    case withoutBackButton
}

struct ProfileTitle: View {
    let title: String
    let type: TitleType

    @Environment(\.dismiss) var dismiss // Дисмиш для закрытия текущего экрана

    var body: some View {
        HStack {
            if type == .withBackButton {
                Button(action: {
                    dismiss() // Закрываем экран при нажатии кнопки
                }) {
                    Image(systemName: Resources.Image.arrowLeft)
                        .foregroundColor(Color.newsText)
                        .frame(width: 24, height: 24)
                }
            }
            Text(title)
                .font(.interSemiBold(24))
                .foregroundColor(Color.newsText)
                .lineSpacing(8)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: type == .withBackButton ? .center : .leading)
                .padding(.trailing, 54)
        }
    }
}

struct Title_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTitle(title: "Terms & COnditions", type: .withBackButton)
            .padding(20)
    }
}
