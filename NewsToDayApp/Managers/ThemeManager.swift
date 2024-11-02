//
//  ThemeManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 02.11.2024.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @AppStorage("themeMode") var userTheme: ThemeMode = .system {
        didSet {
            applyTheme()
        }
    }
    
    init() {
        applyTheme()
    }
    
    func applyTheme() {
        let userInterfaceStyle: UIUserInterfaceStyle
        
        switch userTheme {
        case .light:
            userInterfaceStyle = .light
        case .dark:
            userInterfaceStyle = .dark
        case .system:
            userInterfaceStyle = .unspecified
        }
        
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene }).first?.windows.first {
            window.overrideUserInterfaceStyle = userInterfaceStyle
        }
    }
    
}
