//
//  CacheEntry.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - CacheEntry
// A class representing a single cache entry with a key, value, and expiration timestamp
final class CacheEntry<V> {
    
    let key: String
    let value: V
    let expiredTimestamp: Date
    
    // MARK: - Initializer
    // Initializes a cache entry with a key, value, and expiration timestamp
    init(key: String, value: V, expiredTimestamp: Date) {
        self.key = key
        self.value = value
        self.expiredTimestamp = expiredTimestamp
    }
    
    // MARK: - Check Expiration
    // Determines if the cache entry has expired based on the current date
    func isCacheExpired(after date: Date = .now) -> Bool {
        return date > expiredTimestamp
    }
}

// MARK: - Codable Conformance
// Extends CacheEntry to conform to Codable when the value type (V) is also Codable
extension CacheEntry: Codable where V: Codable {}
