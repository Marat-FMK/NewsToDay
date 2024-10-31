//
//  NewsToDayAppApp.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct NewsToDayAppApp: App {
    
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: StorageManager.UserDefaultKeys.checkFirstLoud) {
                let newsAPIManager = NewsAPIManager()
                let mainViewModel = MainViewModel(newsAPIManager: newsAPIManager)

                CustomTabBarView(mainViewModel: mainViewModel)
            } else {
                OnboardingView()
            }
            let model = AuthViewModel()
            SignInScreen(viewModel: model)
        }
        
    }
}
