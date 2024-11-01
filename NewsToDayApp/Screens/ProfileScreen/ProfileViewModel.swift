//
//  ProfileViewModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    
    private let router: StartRouter
    
    // MARK: Initialization
    init(router: StartRouter) {
        self.router = router
    }
    
    //MARK: - NavigationState
    func openApp() {
        router.updateRouterState(with: .userLoggedOut)
    }
}
