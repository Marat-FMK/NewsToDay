//
//  LanguageManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 31.10.2024.
//


import SwiftUI

enum Language: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case en = "en"
    case ru = "ru"
    
    var locale: Locale {
        Locale(identifier: self.rawValue)
    }
    
    var displayName: String {
        switch self {
        case .en: return "English"
        case .ru: return "Русский"
        }
    }
}


// MARK: - LocalizationService
// A service class responsible for managing the app's language settings
final class LocalizationManager {
    
    // MARK: - Properties
    // Singleton instance of LocalizationService
    public static let shared = LocalizationManager()
    
    // The currently selected language
    var language: Language {
        get {
            // Retrieves the selected language from UserDefaults, or defaults to English if not set
            guard let languageString = UserDefaults.standard.string(forKey: "selectedLanguage") else {
                saveLanguage(.en)
                return .en
            }
            
            // Returns the stored language or defaults to English if the value is invalid
            return Language(rawValue: languageString) ?? .en
        }
        set {
            // Updates the language if it has changed
            if newValue != language {
                saveLanguage(newValue)
            }
        }
    }
    
    // MARK: - Init
    private init() { }
    
    // MARK: - Methods
    // Saves the selected language to UserDefaults and updates the system language setting
    private func saveLanguage(_ language: Language) {
        UserDefaults.standard.setValue(language.rawValue, forKey: "selectedLanguage")
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
    }
}
