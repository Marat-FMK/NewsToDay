//
//  APIClient.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - APIClient
// A simple API client to handle network requests with support for middlewares
struct APIClient {
    private var baseUrl: URL
    private var URLSession: URLSession
    private(set) var middlewares: [any APIClient.Middleware]
    
    // MARK: - Initializer
    // Initializes the API client with a base URL, optional middlewares, and a URLSession (default: .shared)
    init(
        baseUrl: URL,
        middlewares: [any APIClient.Middleware] = [],
        URLSession: URLSession = .shared
    ) {
        self.baseUrl = baseUrl
        self.middlewares = middlewares
        self.URLSession = URLSession
    }
    
    // MARK: - Sending API Request
    // Sends an API request based on the provided APISpec, applies middleware, and decodes the response
    func sendRequest(_ apiSpec: APISpec) async throws -> DecodableType {
        // Construct the full URL from base URL and endpoint
        guard let url = URL(string: baseUrl.absoluteString + apiSpec.endpoint) else {
            throw NetworkError.invalidURL
        }
        
        // Prepare the URL request with method, headers, and body
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 30.0
        )
        request.httpMethod = apiSpec.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = apiSpec.body
        
        // Apply middlewares to modify the request
        var updatedRequest = request
        for middleware in middlewares {
            updatedRequest = try await middleware.intercept(updatedRequest)
        }
        
        // Send the request and handle the response
        var responseData: Data? = nil
        do {
            let (data, response) = try await URLSession.data(for: updatedRequest)
            try handleResponse(data, response)
            responseData = data
        } catch {
            throw error
        }
        
        // Decode the response data into the expected return type
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(apiSpec.returnType, from: responseData!)
            return decodedData
        } catch let error as DecodingError {
            throw error
        } catch {
            throw NetworkError.dataConversionFailure
        }
    }
    
    // MARK: - Response Validation
    // Checks if the response is valid and the status code is within the 200-299 range
    func handleResponse(_ data: Data, _ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }
    
    // MARK: - Error Handling Wrapper
    // A helper method to wrap async calls and propagate errors
    func wrapCatchingErrors<R>(work: () async throws -> R) async throws -> R {
        do {
            return try await work()
        } catch {
            throw error
        }
    }
}

// MARK: - APISpec and HttpMethod Definitions
extension APIClient {
    // Protocol that defines the specifications for an API request
    protocol APISpec {
        var endpoint: String { get }
        var method: HttpMethod { get }
        var returnType: DecodableType.Type { get }
        var body: Data? { get }
    }
    
    // Enum for supported HTTP methods
    enum HttpMethod: String, CaseIterable {
        case get = "GET"
        case patch = "PATCH"
        case head = "HEAD"
        case optional = "OPTIONAL"
    }
}

// MARK: - Middleware Protocol
extension APIClient {
    // Middleware protocol to intercept and modify requests
    protocol Middleware {
        func intercept(_ request: URLRequest) async throws -> URLRequest
    }
}

// MARK: - DecodableType Protocol
// Custom protocol to define types that can be decoded
protocol DecodableType: Decodable {}

// MARK: - Array Conformance to DecodableType
// Allows arrays of DecodableType to also conform to DecodableType
extension Array: DecodableType where Element: DecodableType {}

// MARK: - URLRequest Extension
// Adds a method to describe the URLRequest in a more readable format for debugging purposes
extension URLRequest {
    public var customDescription: String {
        var description = ""
        
        if let method = self.httpMethod {
            description += method
        }
        if let urlString = self.url?.absoluteString {
            description += " " + urlString
        }
        if let headers = self.allHTTPHeaderFields, !headers.isEmpty {
            description += "\nHeaders: \(headers)"
        }
        if let bodyData = self.httpBody,
           let body = String(data: bodyData, encoding: .utf8) {
            description += "\nBody: \(body)"
        }
        
        return description.replacingOccurrences(of: "\\n", with: "\n")
    }
}
