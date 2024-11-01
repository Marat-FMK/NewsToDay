//
//  ProfileViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    
    private let router: StartRouter
    private let authManager = FirebaseManager.shared
    
    // MARK: Initialization
    init(router: StartRouter) {
        self.router = router
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
