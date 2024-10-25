//
//  CategoriesViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

final class CategoriesViewModel: ObservableObject {
    // MARK: Properties
    @Published var categories: [Categories] = []
    
    private let storageManager = StorageManager.shared
    
    // MARK: Methods
    func saveCategories() {
        storageManager.saveCategories(categories: categories)
    }
    
    func loadCategories() {
        self.categories = storageManager.loadCategories() ?? []
    }
}
