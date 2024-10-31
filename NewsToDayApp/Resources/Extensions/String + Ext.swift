//
//  String + Ext.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 31.10.2024.
//


import Foundation

extension String {
    func localized(_ language: Language) -> String {
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            print("Failed to find path for language: \(language.rawValue)")
            return self
        }
        
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}