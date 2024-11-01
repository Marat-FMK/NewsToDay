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
    
    private let router: StartRouter
    
    // MARK: Initialization
    init(router: StartRouter) {
        self.router = router
    }
    
    // MARK: Methods
    func saveCategories() {
        storageManager.saveCategories(categories: categories)
    }
    
    func loadCategories() {
        self.categories = storageManager.loadCategories() ?? []
    }
    
    // MARK: - NavigationState
    func categoryChosen() {
        router.updateRouterState(with: .categoriesSelected)
    }
    
}
