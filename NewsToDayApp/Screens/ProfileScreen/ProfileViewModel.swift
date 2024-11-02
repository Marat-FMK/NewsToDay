//
//  ProfileViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: UserModel? = nil
    @Published var selectedAvatar = "chinatown"
    
    var userName: String {
        guard let user else { return ""}
        return user.userName
    }
    
    var userEmail: String {
        guard let user else { return ""}
        return user.email
    }
    
    private let router: StartRouter
    private let authManager = FirebaseManager.shared
    
    // MARK: Initialization
    init(router: StartRouter) {
        self.router = router
    }
    
    func fetchUserData() {
        Task {
            do {
                user = try await authManager.getUserData()
                selectedAvatar = user?.userImage ?? "chinatown"
            } catch {
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    func updateUserImage() async {
        do {
            try await authManager.saveUserImageName(userImageName: selectedAvatar)
        } catch {
            print("Error updating user image: \(error)")
        }
    }
    
    func setUserAvatar(_ avatar: String) {
        selectedAvatar = avatar
        Task {
            await updateUserImage()
        }
    }
    
    func logOut() async {
        do {
            try await authManager.signOut()
            openApp()
        } catch {
            print(error)
        }
    }
    
    //MARK: - NavigationState
    func openApp() {
        router.updateRouterState(with: .userLoggedOut)
    }
}
