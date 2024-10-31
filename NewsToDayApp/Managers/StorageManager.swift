//
//  StorageManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 24.10.2024.
//

import Foundation

protocol IUserDefaultManager {
    func saveCategories(categories: [Categories])
    func loadCategories() -> [Categories]?
}

final class StorageManager: IUserDefaultManager {
    // MARK: - Properties
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    
    enum UserDefaultKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let hasChooseCategory = "hasChooseCategory"
        static let chooseCategory = "chooseCategory"
    }
    
    // MARK: - Initialization
    private init() {}
    
    
    // MARK: - Categories
    func saveCategories(categories: [Categories]) {
        let categoriesArray = categories.map(\.rawValue)
        userDefaults.set(categoriesArray, forKey: UserDefaultKeys.chooseCategory)
    }
    
    func loadCategories() -> [Categories]? {
        userDefaults
            .array(forKey: UserDefaultKeys.chooseCategory)
            .flatMap { $0 as? [String] }
            .map { $0.compactMap(Categories.init) }
    }
    
    func hasChooseCategory() -> Bool {
        let hasChooseCategory = userDefaults.bool(forKey: UserDefaultKeys.hasChooseCategory)
        return hasChooseCategory
    }
    
    // MARK: - Onboarding
    func completeOnboarding() {
        userDefaults.set(true, forKey: UserDefaultKeys.hasSeenOnboarding)
    }
    
    func hasCompletedOnboarding() -> Bool {
        userDefaults.bool(forKey: UserDefaultKeys.hasSeenOnboarding)
    }

}
