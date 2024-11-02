//
//  StartRouterView.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 31.10.2024.
//

import SwiftUI

struct StartRouterView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject var startRouter = StartRouter()
    let newsAPIManager = NewsAPIManager()
    
    var body: some View {
        Group {
            switch startRouter.routerState {
            case .onboarding:
                OnboardingView(router: startRouter)
            case .categories:
                CategoriesView(mode: .onboarding, router: startRouter)
            case .auth:
                SignInScreen(router: startRouter)
            case .main:
                CustomTabBarView(router: startRouter, newsAPIManager: newsAPIManager)
                    .environmentObject(themeManager)
            }
        }
        .transition(.opacity)
        .animation(.bouncy, value: startRouter.routerState)
    }
}

#Preview {
    StartRouterView()
}
