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
    
    func loadCategories() {}
    
    func saveCategories() {}
}
