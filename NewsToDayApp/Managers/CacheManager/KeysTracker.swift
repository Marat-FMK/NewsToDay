//
//  KeysTracker.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - KeysTracker
// A class that tracks the keys of cached entries and responds to cache eviction events
final class KeysTracker<V>: NSObject, NSCacheDelegate {
    
    // A set to keep track of all cache keys
    var keys = Set<String>()
    
    // MARK: - NSCacheDelegate Method
    // Removes the key from the set when the associated cache entry is evicted
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        guard let entry = obj as? CacheEntry<V> else {
            return
        }
        keys.remove(entry.key)
    }
}
