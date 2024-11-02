//
//  NewsToDayAppApp.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI
import FirebaseCore

@main
struct NewsToDayAppApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            StartRouterView()
                .preferredColorScheme(themeManager.userTheme.colorScheme)
        }
    }
}

