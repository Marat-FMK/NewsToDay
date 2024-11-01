//
//  StartRouter.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 31.10.2024.
//


import Foundation
import FirebaseAuth

final class StartRouter: ObservableObject {
    
    // MARK: - Published Properties
    @Published var routerState: RouterState = .onboarding
    
    private let storage = StorageManager.shared
    private let authManager = FirebaseManager.shared
    
    // MARK: - State & Event Enums
    enum RouterState {
        case onboarding
        case categories
        case auth
        case main
    }
    
    enum StartEvent {
        case onboardingCompleted
        case userAuthorized
        case userLoggedOut
        case categoriesSelected
    }
    
    // MARK: - Initializer
    init() {
        updateRouterState(with: .onboardingCompleted)
    }
    
    // MARK: - State Management
    private func reduce(_ state: RouterState, event: StartEvent) -> RouterState {
        var newState = state
        switch event {
            
        case .onboardingCompleted:
            newState = rootState(state: newState)
        case .userAuthorized:
            newState = storage.hasChooseCategory() ? .main : .categories
        case .userLoggedOut:
            newState = .onboarding
        case .categoriesSelected:
            newState = .main
        }
        return newState
    }
    
    // MARK: - Public Methods
    func updateRouterState(with event: StartEvent) {
        Task {
            await MainActor.run {
                routerState = reduce(routerState, event: event)
            }
        }
    }
    
    // MARK: - Private Helpers
    private func rootState(state: RouterState) -> RouterState {
        var newState = state
        if storage.hasCompletedOnboarding() {
            newState = authManager.isAuthenticated() ? .main : .auth
        } else {
            newState = .onboarding
            storage.completeOnboarding()
        }
        return newState
    }
}
