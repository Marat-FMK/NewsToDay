//
//  AuthTextButton.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 30.10.2024.
//

import SwiftUI

struct AuthTextButton: View {
    private enum Drawing {
        static let fontSize: CGFloat = 16
        static let title = DS.Colors.blackLighter
        static let sign = Color.newsText
  
        
    }
    
    let title: String
    let sign: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                    Text(title)
                        .font(.system(size: Drawing.fontSize))
                        .foregroundStyle(Drawing.title)
                    Text(sign)
                    .font(.system(size: Drawing.fontSize))
                    .foregroundStyle(Drawing.sign)
                    
            }
        }
    }
}
