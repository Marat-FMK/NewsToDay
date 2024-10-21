//
//  AuthorizationMiddleware.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - AuthorizationMiddleware
// Middleware to add Authorization header to API requests
final class AuthorizationMiddleware: APIClient.Middleware {
    
    // Token used for authorization (e.g., JWT token)
    var token: String?
    
    // MARK: - Initializer
    // Optionally initializes with a token, default is nil
    init(token: String? = nil) {
        self.token = token
    }
    
    // MARK: - Intercept Request
    // Intercepts the request to add Authorization header before sending it
    func intercept(_ request: URLRequest) async throws -> (URLRequest) {
        var requestCopy = request
        // Adds the "Bearer" token to the request header
        requestCopy.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        return requestCopy
    }
}
