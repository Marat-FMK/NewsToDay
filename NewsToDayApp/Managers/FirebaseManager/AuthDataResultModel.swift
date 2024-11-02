//
//  AuthDataResultModel.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 02.11.2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel: Codable {
    let uid: String            // The unique identifier for the user
    var userName: String       // The user's display name
    let email: String          // The user's email address
    let profileImageURL: String?  // The URL of the user's profile image (optional)

    // MARK: - CodingKeys
    // Custom keys for encoding/decoding, in case the property names differ from the JSON keys
    enum CodingKeys: String, CodingKey {
        case uid
        case userName
        case email
        case profileImageURL
    }
    
    // MARK: - Initializer
    // Initializes the model using a Firebase `User` object
    init(user: User) {
        self.uid = user.uid
        self.userName = user.displayName ?? ""
        self.email = user.email ?? ""
        self.profileImageURL = user.photoURL?.absoluteString
    }
}
