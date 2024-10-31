//
//  LanguageManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 31.10.2024.
//


import SwiftUI

enum Language: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case english = "en"
    case russian = "ru"
    
    var locale: Locale {
        Locale(identifier: self.rawValue)
    }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .russian: return "Русский"
        }
    }
}


class LocalizationManager {
    static let shared = LocalizationManager()
    
    @AppStorage("selectedLanguage") private var language: String = Locale.current.identifier
    
    var currentLocale: Locale {
        Locale(identifier: language)
    }
    
    func setLanguage(_ languageCode: String) {
        self.language = languageCode
    }
}
