//
//  NetworkManager.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

class NetworkManager {
    private(set) var apiClient: APIClient?
    init(apiClient: APIClient?) {
        self.apiClient = apiClient
    }
}
