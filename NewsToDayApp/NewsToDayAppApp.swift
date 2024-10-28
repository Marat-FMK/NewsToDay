//
//  NewsToDayAppApp.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

@main
struct NewsToDayAppApp: App {
    
    var body: some Scene {
        WindowGroup {
//            if UserDefaults.standard.bool(forKey: StorageManager.UserDefaultKeys.checkFirstLoud){
                let newsAPIManager = NewsAPIManager()
                let mainViewModel = MainViewModel(newsAPIManager: newsAPIManager)
                
                CustomTabBarView(mainViewModel: mainViewModel)
//            } else {
//                OnboardingView()
//            }
        }
    }
}
