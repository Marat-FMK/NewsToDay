//
//  LanguageScreen.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

struct LanguageScreen: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            ProfileTitle(title: "Language".localized(language), type: .withBackButton)
                .padding(.top, 68)
                .padding(.horizontal, 20)
            // MARK: Language List
            List(Language.allCases) { lang in
                CustomButton(
                    title: lang.displayName,
                    action: {
                        LocalizationManager.shared.language = lang
                    },
                    buttonType: .language,
                    isSelected: language == lang
                )
                .frame(height: 56)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            
            .listStyle(PlainListStyle())

        }
        .navigationBarHidden(true)
        .background(.background)
        .ignoresSafeArea()
    }
}

struct Language_Previews: PreviewProvider {
    static var previews: some View {
        LanguageScreen()
    }
}
