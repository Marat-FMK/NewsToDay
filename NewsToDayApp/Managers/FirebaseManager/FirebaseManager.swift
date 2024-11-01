//
//  FireStoreManager.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 30.10.2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private init() {}
    
    
    func isAuthenticated() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    
    func getUserData(userId: String) async throws -> UserModel {
        let document = try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .getDocument()
        
        guard let data = document.data() else {
            throw FirebaseError.missingDocument
        }
        
        guard let name = data["userName"] as? String else {
            throw FirebaseError.missingField(fieldName: "userName")
        }
        
        guard let email = data["email"] as? String else {
            throw FirebaseError.missingField(fieldName: "email")
        }
        
        
        return UserModel(id: userId,
                         userName: name,
                         email: email)
    }
    
    func getUserCategories(userId: String) async throws -> [Categories] {
        
        let document = try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .getDocument()
        
        guard let data = document.data() else {
            throw FirebaseError.missingDocument
        }
        
        guard let favoriteCategoriesRawValue = data["favoriteCategories"] as? [String] else {
            throw FirebaseError.missingField(fieldName: "favoriteCategories")
        }
        return favoriteCategoriesRawValue.compactMap { Categories(rawValue: $0) }
    }
    
    func saveUserData(userId: String, name: String, email: String) {
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .setData([
                "userName": name,
                "email": email
            ])
    }
    
    func saveFavoriteCategory(userId: String, categories: [Categories]) {
        let categoriesRawValues = categories.map { $0.rawValue }
        
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .setData([
                "favoriteCategories": categoriesRawValues
            ], merge: true) { error in
                if let error = error {
                    print("Error saving favorite categories: \(error.localizedDescription)")
                } else {
                    print("Favorite categories saved successfully")
                }
            }
    }
    
}
