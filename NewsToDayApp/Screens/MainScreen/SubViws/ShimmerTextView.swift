//
//  ShimmerTextView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 27.10.2024.
//

import SwiftUI

struct ShimmerTextView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Resources.Text.loading.localized(language) + " ...")
                .foregroundStyle(DS.Colors.purplePrimary)
                .frame(width: 224, height: 20, alignment: .leading)
                .shimmering()
            
            Text("some title    ")
                .font(.interMedium(28))
                .frame(width: 224, height: 20, alignment: .leading)
                .redacted(reason: .placeholder)
                .shimmering()
            
            Text("some info")
                .redacted(reason: .placeholder)
                .shimmering()
        }
    }
}

#Preview {
    ShimmerTextView()
}
