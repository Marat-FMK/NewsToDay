//
//  SignInModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthError: LocalizedError, Equatable {
    case validationError
    case validationSignUpError
    case signInError(error: Error)
    case signUpError(error: Error)
    case signUpSuccess
    case customError(message: String)
    
    static func == (lhs: AuthError, rhs: AuthError) -> Bool {
            switch (lhs, rhs) {
            case (.validationError, .validationError),
                 (.validationSignUpError, .validationSignUpError),
                 (.signUpSuccess, .signUpSuccess):
                return true
            case (.signInError, .signInError),
                 (.signUpError, .signUpError):
                return true 
            case (.customError(let lhsMessage), .customError(let rhsMessage)):
                return lhsMessage == rhsMessage
            default:
                return false
            }
        }
    
    var failureReason: String? {
        switch self {
        case .validationError:
            return "Incorrect form input."
        case .validationSignUpError:
            return "The signup form is invalid."
        case .signInError(let error):
            return "Sign in failed: \(error.localizedDescription)"
        case .signUpError(let error):
            return "Sign up failed: \(error.localizedDescription)"
        case .customError(let message):
            return message
        case .signUpSuccess:
            return "Sign Up was successful"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .validationError:
            return "Please fill all fields correctly."
        case .validationSignUpError:
            return "Please ensure all fields are correct and passwords match."
        case .signInError(let error):
            return error.localizedDescription
        case .signUpError(let error):
            return error.localizedDescription
        case .customError(let message):
            return message
        case .signUpSuccess:
            return "Your account has been created successfully."
        }
    }
}


final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userName: String = ""
    @Published var reEnterPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var isSignedIn: Bool = false
    @Published var authError: AuthError?
    
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
    
    func cancelErrorAlert() {
        authError = nil
    }
    
    func signIn() {
        guard formIsValid else {
            authError = .validationError
            return
        }
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            
            if let error = error {
                self?.authError = .signInError(error: error)
            } else {
                self?.userAuthenticated()
            }
        }
    }
    
    func signUp() {
        guard signUpFormIsValid else {
            authError = .validationSignUpError
            return
        }
        Task {
            do {
                let authResult = try await firebaseManager.createUser(email: email, password: password)
                let user = UserModel(id: authResult.uid, userName: userName, email: email)
                await saveUserData(userModel: user)
                await MainActor.run { authError = .signUpSuccess }
            } catch {
                await MainActor.run { authError = .signUpError(error: error) }
            }
        }
    }
    
    private func saveUserData(userModel: UserModel) async {
        do {
            try await firebaseManager.saveUserData(userId: userModel.id, name: userModel.userName, email: userModel.email, avatar: nil)
        } catch {
            authError = .customError(message: error.localizedDescription)
        }
    }
    

    //MARK: - NavigationState
    func userAuthenticated() {
        router.updateRouterState(with: .userAuthorized)
    }
}
