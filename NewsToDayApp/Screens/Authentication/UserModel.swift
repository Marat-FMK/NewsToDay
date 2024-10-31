//
//  UserModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

struct UserModel: Identifiable, Codable {
    let id: String
    let userName: String
    let email: String
    var userPhoto: String?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: userName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

