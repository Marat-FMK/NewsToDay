//
//  StorageManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 24.10.2024.
//

import Foundation

final class StorageManager {
    // MARK: - Properties
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    
    enum UserDefaultKeys {
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

}
