//
//  CacheProtocol.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - Cache Protocol
// Defines a protocol for cache behavior, including setting, retrieving, and removing values
protocol Cache: Actor {
    
    associatedtype V
    var expirationInterval: TimeInterval { get }
    
    // MARK: - Methods
    // Sets a value in the cache for the given key
    func setValue(_ value: V?, forKey key: String)
    
    // Retrieves a value from the cache for the given key
    func value(forKey key: String) -> V?
    
    // Removes a value from the cache for the given key
    func removeValue(forKey key: String)
    
    // Removes all values from the cache
    func removeAllValues()
}
