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
    
    var initials: String {
        let formater = PersonNameComponentsFormatter()
        if let components = formater.personNameComponents(from: userName) {
            formater.style = .abbreviated
            return formater.string(from: components)
        }
        return ""
    }
}
