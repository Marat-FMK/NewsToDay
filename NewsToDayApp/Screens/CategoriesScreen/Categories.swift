//
//  Language.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//


import Foundation

enum Language: String, CaseIterable {
    case ru
    case en
}

enum Categories: String, CaseIterable, Hashable, Identifiable {
    var id: String { rawValue }
    case business
    case crime
    case domestic
    case education
    case entertainment
    case environment
    case food
    case health
    case lifestyle
    case other
    case politics
    case science
    case sports
    case technology
    case top
    case tourism
    case world

    
    var image: String {
        switch self {
            case .sports: return "🏈"
            case .politics: return "⚖️"
            case .food: return "🍔"
            case .business: return "💲"
            case .entertainment: return "🗾"
            case .health: return "🚑"
            case .science: return "🧬"
            case .technology: return "👩🏾‍💻"
            case .crime: return "🔫"
            case .domestic: return "🏠"
            case .education: return "🎓"
            case .environment: return "🌳"
            case .lifestyle: return "🎉"
            case .other: return "❓"
            case .top: return "🔝"
            case .tourism: return "🏖️"
            case .world: return "🌍"
        }
    }
    
    var localizedString: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}


