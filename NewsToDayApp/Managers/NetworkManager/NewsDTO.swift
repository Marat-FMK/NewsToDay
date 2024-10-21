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
    let articles: [ArticleDTO] // Array of articles in the response
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }
    
    // MARK: - Custom Decoder for NewsApiResponseDTO
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard !container.allKeys.isEmpty else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Empty object: \(container.allKeys)")
            )
        }
        self.status = try container.decode(String.self, forKey: .status)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.articles = try container.decode([ArticleDTO].self, forKey: .articles)
    }
    
    // MARK: - Initializer
    init(status: String, totalResults: Int, articles: [ArticleDTO]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

// MARK: - ArticleDTO
// Represents an individual article in the API response
struct ArticleDTO: Sendable, Codable, DecodableType {
    var id: String? {
        return UUID().uuidString // Generates a unique identifier if not present
    }
    let source: Source           // Source of the article
    let author: String?          // Author of the article (optional)
    let title: String            // Title of the article
    let description: String      // Short description of the article
    let url: String              // URL to the full article
    let urlToImage: String?      // URL to the article's image (optional)
    let publishedAt: String        // Publication date
    let content: String?         // Full content of the article (optional)
    
    enum CodingKeys: String, CodingKey {
        case source = "source"
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
    
    // MARK: - Custom Decoder for ArticleDTO
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard !container.allKeys.isEmpty else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Empty object: \(container.allKeys)")
            )
        }
        self.source = try container.decode(Source.self, forKey: .source)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.url = try container.decode(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
    }
    
    // MARK: - Initializer
    init(source: Source, author: String?, title: String, description: String, url: String, urlToImage: String?, publishedAt: String, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

// MARK: - Source
// Represents the source of an article
struct Source: Sendable, Codable, DecodableType {
    let id: String?   // Optional ID of the source
    let name: String  // Name of the source
    
    // MARK: - Custom Decoder for Source
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard !container.allKeys.isEmpty else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Empty object: \(container.allKeys)")
            )
        }
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    // MARK: - Initializer
    init(id: String?, name: String) {
        self.id = id
        self.name = name
    }
}
