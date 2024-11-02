//
//  CustomToolBar 2.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 23.10.2024.
//

import SwiftUI

struct CustomToolBar: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    let title: String
    let subTitle: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(title.localized(language))
                .foregroundStyle(Color.newsText)
                .font(.interSemiBold(24))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Text(subTitle.localized(language))
                .foregroundStyle(DS.Colors.grayPrimary)
                .font(.interSemiBold(16))
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding(.top, 72)
        .padding(.horizontal)
        .background(.newsBackground)
    }
}


//#Preview {
//    CustomToolBar(title: "MainTitle", subTitle: "same text")
//}
