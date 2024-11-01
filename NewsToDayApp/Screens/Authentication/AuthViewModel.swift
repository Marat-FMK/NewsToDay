//
//  SignInModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userName: String = ""
    @Published var reEnterPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var isSignedIn: Bool = false
    @Published var errorMessage: String?
    
    private let router: StartRouter
    private let firebaseManager = FirebaseManager.shared
    
    var formIsValid: Bool {
        return !email.isEmpty && !password.isEmpty && password.count >= 6 && !password.contains(" ")
    }

    var signUpFormIsValid: Bool {
        return !email.isEmpty &&
               !password.isEmpty &&
               password.count >= 6 &&
               password == reEnterPassword &&
               !userName.isEmpty &&
               !password.contains(" ") &&
               !email.contains(" ")
    }
    

    
    // MARK: Initialization
    init(router: StartRouter) {
        self.router = router
    }
    
    func signIn() {
        guard formIsValid else {
            errorMessage = "Please fill all fields correctly."
            return
        }
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            
            if error == nil {
                self?.userAuthenticated()
                print("Verification was successful")
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func signUp() {
        guard signUpFormIsValid else {
            errorMessage = "Please ensure all fields are correct and passwords match."
            return
        }
        isLoading = true
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                firebaseManager.saveUserData(userId: authResult.user.uid, name: userName, email: email)
                try await authResult.user.sendEmailVerification()
            } catch {
                print("Ошибка при регистрации: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    private func saveUserData(userModel: UserModel) {
        firebaseManager.saveUserData(userId: userModel.id, name: userModel.userName, email: userModel.email)
    }
    
    func fetchUserData(userId: String) {
        Task {
            do {
                let userModel = try await firebaseManager.getUserData(userId: userId)
                DispatchQueue.main.async {
                    self.userName = userModel.userName
                    self.email = userModel.email
                    self.password = "" // Очистка пароля для безопасности
                }
            } catch {
                print("Error fetching user data: \(error)")
            }
        }
    }
    //MARK: - NavigationState
    func userAuthenticated() {
        router.updateRouterState(with: .userAuthorized)
    }
}
