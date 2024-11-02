//
//  CustomTabBar.swift
//  NewsToDayApp
//
//  Created by on 20.10.2024.
//

import SwiftUI

struct CustomTabBar: View {
    
    // MARK: - Drawing Constants
    private struct Drawing {
       static let tabBarHeight: CGFloat = 96
       static let tabBarCorner: CGFloat = 12
       static let tabBarTitlePadding: CGFloat = 28
       static let tabBarTitleOffset: CGFloat = 12
       static let tabBarTitleWH: CGFloat = 24
    }
    // MARK: - Properties
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [String] = [
        "house",
        "squareshape.split.2x2",
        "bookmark",
        "person"
    ]
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: Drawing.tabBarCorner)
                .frame(height: Drawing.tabBarHeight)
                .foregroundColor(.newsBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: Drawing.tabBarCorner)
                        .stroke(DS.Colors.grayLight, lineWidth: 1)
                        .mask(
                            RoundedRectangle(cornerRadius: Drawing.tabBarCorner)
                                .frame(height: Drawing.tabBarHeight)
                                .offset(y: -1)
                        )
                )
            
            HStack {
                ForEach(tabBarItems, id: \.self) { item in
                    createTabBarButton(imageName: item)
                }
            }
            .frame(height: Drawing.tabBarHeight )
        }
        
    }
    
    // MARK: - Private Methods
    private func createTabBarButton(imageName: String) -> some View {
        let index = tabBarItems.firstIndex(of: imageName) ?? 0
        let isSelected = index + 1 == tabSelection
        
        return Button {
            tabSelection = index + 1
        } label: {
            VStack() {
                
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Drawing.tabBarTitleWH, height: Drawing.tabBarTitleWH)
                    .padding(Drawing.tabBarTitlePadding)
                    .offset(y: -Drawing.tabBarTitleOffset)
            }
            .foregroundColor(isSelected
                             ? DS.Colors.purpleDark
                             : DS.Colors.grayLight)
        }
    }
}

//#Preview {
//    CustomTabBar(tabSelection: .constant(1))
//}
