//
//  CustomToolBar 2.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 23.10.2024.
//

import SwiftUI

struct CustomToolBar: View {
    let title: String
    let subTitle: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(DS.Colors.blackyPrimary)
                .font(.interSemiBold(32))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Text(subTitle)
                .foregroundStyle(DS.Colors.grayPrimary)
                .font(.interSemiBold(16))
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding(.top, 72)
        .padding(.horizontal)
        .background(.background)
    }
}


//#Preview {
//    CustomToolBar(title: "MainTitle", subTitle: "same text")
//}
