//
//  LanguageScreen.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

struct LanguageScreen: View {
    
    @State private var isRussian: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            ProfileTitle(title: "Language", type: .withBackButton)
                .padding(.top, 68) // Отступ сверху, если нужно
                .padding(.horizontal, 20)
    
            CustomButton(
                title: "English",
                imageName: "checkmark",
                action: {
                    changeLanguage()
                }, buttonType: .language,
                isSelected: isRussian == false)
            .padding(.horizontal, 20)
            .padding(.top, 0)
        
            CustomButton(
                title: "Russian",
                imageName: "checkmark",
                action: {
                    changeLanguage()
                }, buttonType: .language,
                isSelected: isRussian == true)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background(.background)
        .ignoresSafeArea()
    }
    
    private func changeLanguage() {
        isRussian.toggle()
    }
}
    
struct Language_Previews: PreviewProvider {
    static var previews: some View {
        LanguageScreen()
    }
}
