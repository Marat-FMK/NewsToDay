//
//  NetworkManager.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 21.10.2024.
//


import Foundation
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
    case dataConversionFailure
}

struct ApiClient {
    private var baseUrl: URL
    private var URLSession: URLSession
    
    init(
        baseUrl: URL,
        URLSession: URLSession = .shared
    ) {
        self.baseUrl = baseUrl
        self.URLSession = URLSession
    }
    
    func sendRequest(_ apiSpec: APISpec) async throws -> DecodableType {
        guard let url = URL(string: baseUrl.absoluteString + apiSpec.endpoint) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: TimeInterval(floatLiteral: 30.0)
        )
        request.httpMethod = apiSpec.method.rawValue
        request.setValue("appkication/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = apiSpec.body
        var responseData: Data? = nil
        
        do {
            let (data, response) = try await URLSession.data(for: request)
            try handleResponse(data, response)
            responseData = data
        } catch {
            throw error
        }
        
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(
                apiSpec.returnType,
                from: responseData!
            )
            return decodeData
        } catch let error as DecodingError {
            throw error
        } catch {
            throw NetworkError.dataConversionFailure
        }
    }
    
    func handleResponse(_ data: Data,_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }
}

extension ApiClient {
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

protocol DecodableType: Decodable {}

extension Array: DecodableType where Element: DecodableType {}
