//
//  NetworkError.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

// MARK: - NetworkError
// Enum to represent different network errors that can occur
enum NetworkError: Error {
    case invalidURL                    // Error when URL is invalid
    case invalidResponse               // Error for non-HTTP response
    case requestFailed(statusCode: Int) // Error when HTTP status code is not in 200-299 range
    case dataConversionFailure         // Error when data decoding fails
}

enum NewsAPIManagerError: Error {
    case noUserIdFound
}
