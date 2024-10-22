//
//  to.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 22.10.2024.
//


import Foundation

// MARK: - DataFetchPhase Enum
// A generic enum to represent the different phases of data fetching
enum DataFetchPhase<T> {
    case empty                 // No data has been fetched yet
    case success(T)            // Data was fetched successfully, with the data stored in the associated value
    case failure(Error)        // Data fetching failed, with the error stored in the associated value
    
    // MARK: - Computed Property
    // A computed property that returns the associated value in case of a successful fetch
    var value: T? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
}