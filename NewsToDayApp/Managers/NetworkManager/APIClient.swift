//
//  APIClient.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - APIClient
struct APIClient {
    private var URLSession: URLSession
    private(set) var middlewares: [any APIClient.Middleware]
    
    // MARK: - Initializer
    init(
        middlewares: [any APIClient.Middleware] = [],
        URLSession: URLSession = .shared
    ) {
        self.middlewares = middlewares
        self.URLSession = URLSession
    }
    
    // MARK: - Sending API Request
    func sendRequest(_ apiSpec: APISpec) async throws -> DecodableType {
        // Construct the full URL
        guard let url = URL(string: apiSpec.endpoint) else {
            throw NetworkError.invalidURL
        }
        
        // Prepare the request
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 30.0
        )
        request.httpMethod = apiSpec.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = apiSpec.body

        // Apply middlewares
        for middleware in middlewares {
            request = try await middleware.intercept(request)
        }

        // Send the request and unwrap the response
        do {
            let (data, response) = try await URLSession.data(for: request)
            // Unwrap the response using unwrapResponse method
            let unwrappedResult = unwrapResponse((data, response))
            switch unwrappedResult {
            case .success(let responseData):
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(apiSpec.returnType, from: responseData)
                return decodedData
            case .failure(let error):
                print("err: \(error)")
                throw error
            }
            
        } catch {
            print("err: \(error)")
            throw error
        }
    }
    
    // MARK: - Response Validation
    // Unwraps and validates the response, returning either data or a failure error
    func unwrapResponse(_ dataResponse: (Data, URLResponse)) -> Result<Data, Error> {
        guard let httpResponse = dataResponse.1 as? HTTPURLResponse else {
            return .failure(NetworkError.invalidResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            return .success(dataResponse.0)
        case 400:
            return .failure(NetworkError.serverError(statusCode: 400, description: "Bad Request"))
        case 401:
            return .failure(NetworkError.serverError(statusCode: 401, description: "Unauthorized"))
        case 403:
            return .failure(NetworkError.serverError(statusCode: 403, description: "Forbidden"))
        case 404:
            return .failure(NetworkError.serverError(statusCode: 404, description: "Not Found"))
        case 500:
            return .failure(NetworkError.serverError(statusCode: 500, description: "Internal Server Error"))
        default:
            return .failure(NetworkError.invalidResponse)
        }
    }
}

// MARK: - APISpec and HttpMethod Definitions
extension APIClient {
    protocol APISpec {
        var endpoint: String { get }
        var method: HttpMethod { get }
        var returnType: DecodableType.Type { get }
        var body: Data? { get }
    }
    
    enum HttpMethod: String, CaseIterable {
        case get = "GET"
        case patch = "PATCH"
        case head = "HEAD"
        case optional = "OPTIONAL"
    }
}

// MARK: - Middleware Protocol
extension APIClient {
    protocol Middleware {
        func intercept(_ request: URLRequest) async throws -> URLRequest
    }
}

// MARK: - DecodableType Protocol
protocol DecodableType: Decodable {}

// Conform Array to DecodableType where Element is DecodableType
extension Array: DecodableType where Element: DecodableType {}

// MARK: - URLRequest Extension for Debugging
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
