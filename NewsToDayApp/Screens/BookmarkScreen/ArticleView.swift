//
//  ArticleView.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 23.10.2024.
//

import SwiftUI

struct ArticleView: View {
    
    let model: ArticleDTO
       
       var body: some View {
           HStack() {
               AsyncCachedImage(
                url: URL(string: model.imageUrl ?? ""),
                   placeholder: Image(systemName: "photo")
               )
               .frame(width: 96, height: 96)
               .clipShape(RoundedRectangle(cornerRadius: 12))
           
               
               VStack(alignment: .leading) {
                   Text(model.title)
                       .font(.custom("Inter", size: 14)) 
                       .fontWeight(.semibold)
                       .foregroundColor(Color(.black))
                       .lineSpacing(20 - 14)
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .padding(.vertical, 8)

                   
                   Text(model.category?.first ?? "")
                       .font(.system(size: 16, weight: .semibold))
                       .foregroundColor(Color(.black))
                       .lineSpacing(24 - 16)
                       .frame(height: 50, alignment: .top)
                       .padding(.bottom, 8)
                       .lineLimit(2)
               }
               .frame(maxWidth: .infinity)
               .padding(.init(top: .zero, leading: 16, bottom: .zero, trailing: .zero))
           }
       }
}
