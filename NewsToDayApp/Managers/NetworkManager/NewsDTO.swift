//
//  NewsDTO.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//

import Foundation

// MARK: - NewsApiResponseDTO
// Represents the main response structure for the News API
struct NewsApiResponseDTO: Sendable, Decodable, DecodableType {
    let status: String        // Status of the API response (e.g., "ok")
    let totalResults: Int     // Total number of articles returned
    let results: [ArticleDTO] // Array of articles in the response
    
    enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case results
    }
    
    // MARK: - Custom Decoder for NewsApiResponseDTO
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard !container.allKeys.isEmpty else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Empty object in NewsApiResponseDTO: \(container.allKeys)"
                )
            )
        }
        self.status = try container.decode(String.self, forKey: .status)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.results = try container.decode([ArticleDTO].self, forKey: .results)
    }
    
    // MARK: - Initializer
    init(status: String, totalResults: Int, results: [ArticleDTO]) {
        self.status = status
        self.totalResults = totalResults
        self.results = results
    }
}

// MARK: - ArticleDTO
// Represents an individual article in the API response
struct ArticleDTO: Sendable, Equatable, Codable, Hashable, Identifiable, DecodableType {
    var id: String {
        return UUID().uuidString
    }
    let title: String
    let link: String?
    let creator: [String]?
    let description: String?
    let content: String?
    let imageUrl: String?
    let category: [String]?
    let country: [String]?
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case creator
        case description
        case content
        case imageUrl
        case category
        case country
        case isFavorite
    }
    
    // MARK: - Custom Decoder for ArticleDTO
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard !container.allKeys.isEmpty else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Empty object in ArticleDTO: \(container.allKeys)"
                )
            )
        }
        self.title = try container.decode(String.self, forKey: .title)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
        self.creator = try container.decodeIfPresent([String].self, forKey: .creator)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.category = try container.decodeIfPresent([String].self, forKey: .category)
        self.country = try container.decodeIfPresent([String].self, forKey: .country)
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
}


