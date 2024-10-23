//
//  AuthorizationMiddleware.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

import Foundation

// MARK: - AuthorizationMiddleware
final class AuthorizationMiddleware: Middleware {
    
    // API Key for authorization (e.g., API key for News API)
    var apiKey: String
    
    // MARK: - Initializer
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Intercept Request
    func intercept(_ request: URLRequest) async throws -> URLRequest {
        guard let originalUrl = request.url else {
            throw NetworkError.invalidURL
        }
        
        // Parse the URL components
        guard var urlComponents = URLComponents(url: originalUrl, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        
        // Add the apiKey as a query item
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: "apiKey", value: apiKey))
        urlComponents.queryItems = queryItems
        
        // Create a copy of the original request with the updated URL
        var requestCopy = request
        requestCopy.url = urlComponents.url
        
        return requestCopy
    }
}
