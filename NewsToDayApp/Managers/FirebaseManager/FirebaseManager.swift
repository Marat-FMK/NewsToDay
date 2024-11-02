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
    
    private init() {}
    
    // MARK: - Authentication Methods
    func isAuthenticated() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        try await authDataResult.user.sendEmailVerification()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - User Data Methods
    func getUserData() async throws -> UserModel? {
        guard let currentUser = Auth.auth().currentUser else { return nil}
        
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
        
        // Extract image URL from Firestore and download UIImage
        var userPhotoData: Data? = nil
        if let avatarURLString = data["avatar"] as? String,
           let avatarURL = URL(string: avatarURLString) {
            let userPhoto = try await downloadImage(from: avatarURL)
            userPhotoData = userPhoto?.jpegData(compressionQuality: 0.8)
        }
        
        return UserModel(id: currentUser.uid, userName: name, email: email, userPhotoData: userPhotoData)
    }
    
    /// Saves user data including image if provided
    func saveUserData(userId: String, name: String, email: String, avatar: UIImage?) async throws {
        var userData: [String: Any] = [
            "userName": name,
            "email": email
        ]
        
        // Upload avatar to Firebase Storage and save URL if image exists
        if let avatar = avatar {
            let avatarURL = try await uploadImage(avatar, for: userId)
            userData["avatar"] = avatarURL.absoluteString
        }
        
        try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .setData(userData)
    }
    
    // MARK: - Image Upload & Download Methods
    /// Uploads image to Firebase Storage and returns its URL
    private func uploadImage(_ image: UIImage, for userId: String) async throws -> URL {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw FirebaseError.invalidImageData
        }
        
        let storageRef = storage.reference().child("avatars/\(userId).jpg")
        let _ = try await storageRef.putDataAsync(imageData)
        return try await storageRef.downloadURL()
    }
    
    /// Downloads UIImage from URL
    private func downloadImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
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
