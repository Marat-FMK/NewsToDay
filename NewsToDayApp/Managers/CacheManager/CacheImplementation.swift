//
//  CacheImplementation.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - NSCacheType Protocol
// A protocol to define the common properties and methods for caches that use NSCache
fileprivate protocol NSCacheType: Cache {
    var cache: NSCache<NSString, CacheEntry<V>> { get }
    var keysTracker: KeysTracker<V> { get }
}

// MARK: - InMemoryCache
// A cache that stores data in memory using NSCache
actor InMemoryCache<V>: NSCacheType {
    fileprivate let cache: NSCache<NSString, CacheEntry<V>> = .init()
    fileprivate let keysTracker: KeysTracker<V> = .init()
    
    let expirationInterval: TimeInterval
    
    init(expirationInterval: TimeInterval) {
        self.expirationInterval = expirationInterval
    }
}

// MARK: - DiskCache
// A cache that stores data on disk and in memory using NSCache
actor DiskCache<V: Codable>: NSCacheType {
    
    fileprivate let cache: NSCache<NSString, CacheEntry<V>> = .init()
    fileprivate let keysTracker: KeysTracker<V> = .init()
    
    let filename: String
    let expirationInterval: TimeInterval
    
    init(filename: String, expirationInterval: TimeInterval) {
        self.filename = filename
        self.expirationInterval = expirationInterval
    }
    
    // MARK: - File Location
    // Returns the URL where the cache file is stored on disk
    private var saveLocationURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(filename).cache")
    }
    
    // MARK: - Save to Disk
    // Saves the cache data to disk
    func saveToDisk() throws {
        let entries = keysTracker.keys.compactMap(entry)
        let data = try JSONEncoder().encode(entries)
        try data.write(to: saveLocationURL)
    }
    
    // MARK: - Load from Disk
    // Loads the cache data from disk
    func loadFromDisk() throws {
        let data = try Data(contentsOf: saveLocationURL)
        let entries = try JSONDecoder().decode([CacheEntry<V>].self, from: data)
        entries.forEach { insert($0) }
    }
}

// MARK: - NSCacheType Extension
// Provides default implementations for NSCacheType methods
extension NSCacheType {
    
    // MARK: - Remove Value
    // Removes a value from the cache
    func removeValue(forKey key: String) {
        keysTracker.keys.remove(key)
        cache.removeObject(forKey: key as NSString)
    }
    
    // MARK: - Remove All Values
    // Clears all values from the cache
    func removeAllValues() {
        keysTracker.keys.removeAll()
        cache.removeAllObjects()
    }
    
    // MARK: - Set Value
    // Adds or updates a value in the cache
    func setValue(_ value: V?, forKey key: String) {
        if let value = value {
            let expiredTimestamp = Date().addingTimeInterval(expirationInterval)
            let cacheEntry = CacheEntry(key: key, value: value, expiredTimestamp: expiredTimestamp)
            insert(cacheEntry)
        } else {
            removeValue(forKey: key)
        }
    }
    
    // MARK: - Get Value
    // Retrieves a value from the cache
    func value(forKey key: String) -> V? {
        entry(forKey: key)?.value
    }
    
    // MARK: - Get Cache Entry
    // Retrieves a cache entry (including metadata) for a given key
    func entry(forKey key: String) -> CacheEntry<V>? {
        guard let entry = cache.object(forKey: key as NSString) else {
            return nil
        }
        
        guard !entry.isCacheExpired(after: Date()) else {
            removeValue(forKey: key)
            return nil
        }
        return entry
    }
    
    // MARK: - Insert Entry
    // Inserts a cache entry into the cache
    func insert(_ entry: CacheEntry<V>) {
        keysTracker.keys.insert(entry.key)
        cache.setObject(entry, forKey: entry.key as NSString)
    }
}
