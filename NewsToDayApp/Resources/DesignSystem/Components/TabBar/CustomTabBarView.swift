//
//  CustomTabBarView.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct CustomTabBarView: View {
    @State private var tabSelection = 1
    private let router: StartRouter
    private let newsAPIManager: NewsAPIManager
    
    init(router: StartRouter, newsAPIManager: NewsAPIManager) {
        self.router = router
        self.newsAPIManager = newsAPIManager
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            switch tabSelection {
            case 1:
                NavigationView {
                    MainView(newsAPIManager)
                }
            case 2:
                CategoriesView(mode: .screen, router: router)
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
