//
//  CustomTabBarView.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct CustomTabBarView: View {
    @State private var tabSelection = 1
    
    let mainViewModel: MainViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            switch tabSelection {
            case 1:
                NavigationView {
                    MainView(viewModel: mainViewModel)
                }
            case 2:
                NavigationView {
                    CategoriesView()
                }
            case 3:
                NavigationView {
                    BookmarkView()
                }
            case 4:
                NavigationView {
                    ProfileView()
                }
            default:
                ProfileView()
            }
            CustomTabBar(tabSelection: $tabSelection)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

//#Preview {
//    CustomTabBarView(mainViewModel: MainViewModel(newsAPIManager: NewsAPIManager()))
//}
