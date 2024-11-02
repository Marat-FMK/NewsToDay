//
//  FireStoreManager.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 30.10.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class FirebaseManager {
    
    // MARK: - Singleton Instance
    static let shared = FirebaseManager()
    
    // MARK: - Properties
    private let storage = Storage.storage()
    private var currentUser: User?
    
    private init() {
        currentUser = Auth.auth().currentUser
    }
    
    // MARK: - Authentication Methods
    func isAuthenticated() -> Bool {
        return currentUser?.uid != nil
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        currentUser = authDataResult.user
        return AuthDataResultModel(user: authDataResult.user)
    }

    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        try await authDataResult.user.sendEmailVerification()
        currentUser = authDataResult.user
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func createAndSaveUser(email: String, password: String, userName: String) async throws -> AuthDataResultModel {
        let authResult = try await createUser(email: email, password: password)
        
        // Save user data to Firestore
        let user = UserModel(id: authResult.uid, userName: userName, email: email)
        try await saveUserData(userId: user.id, name: user.userName, email: user.email, userImageName: nil)
        
        return authResult
    }
    
    func signOut() async throws {
        try Auth.auth().signOut()
        currentUser = nil
    }
    
    // MARK: - User Data Methods
    func getUserData() async throws -> UserModel? {
        guard let currentUser else { return nil }
        
        let document = try await Firestore.firestore()
            .collection("users")
            .document(currentUser.uid)
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
        
        guard let userImageName = data["userImageName"] as? String else {
            throw FirebaseError.missingField(fieldName: "userImageName")
        }
        
        return UserModel(id: currentUser.uid, userName: name, email: email, userImage: userImageName)
    }
    
    /// Saves user data
    func saveUserData(userId: String, name: String, email: String, userImageName: String?) async throws {
        var userData: [String: Any] = [
            "userName": name,
            "email": email
        ]
        
        if let userImageName = userImageName {
            userData["userImageName"] = userImageName
        }
        
        try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .setData(userData, merge: true)
    }
    
    /// Saves only the userImageName to Firestore without affecting other user data fields
    func saveUserImageName(userImageName: String) async throws {
        guard let currentUser else { return }
        let userImageData: [String: Any] = [
            "userImageName": userImageName
        ]
        
        try await Firestore.firestore()
            .collection("users")
            .document(currentUser.uid)
            .setData(userImageData, merge: true)
    }
    
    // MARK: - Category Methods
    /// Saves user's favorite categories
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
