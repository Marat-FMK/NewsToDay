//
//  ProfileView.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    
    @StateObject private var viewModel: ProfileViewModel
    
    @State private var showAlert = false
    @State private var isShowingTermsConditionsScreen = false
    @State private var isShowingLanguageScreen = false
    
    init(router: StartRouter) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(router: router))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ProfileTitle(title: "Profile".localized(language), type: .withoutBackButton)
                .padding(.top, 68)
                .padding(.horizontal, 20)
            
            ProfileHeaderView(avatar: Image("chinatown"), userName: "Dev P", email:  "sdsdasdasd@mail")
                .padding(20)
            //LocalizeLanguage
            
            NavigationLink(destination: LanguageScreen(), isActive: $isShowingLanguageScreen) {
                CustomButton(title: "Language", imageName: nil,
                             action: {
                    isShowingLanguageScreen = true
                },
                             buttonType: .language,
                             isSelected: false)
                .padding(20)
            }
            
            Spacer()
            Spacer()
            Spacer()
            
            NavigationLink(destination: TermsConditionsScreen(), isActive: $isShowingTermsConditionsScreen) {
                CustomButton(
                    title: "Terms & Conditions".localized(language),
                    action: {
                    isShowingTermsConditionsScreen = true
                },
                             buttonType: .profile,
                             isSelected: false
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 0)
            }
            
            CustomButton(
                title: "Sign Out".localized(language),
                action: {
                showAlert = true
                    
                // Действие при нажатии на кнопку "Sign out"
            },
                buttonType: .profile,
                isSelected: false
            )
            .padding(20)
            
            Spacer()
        }
        .padding(.bottom, 20)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure you want to sign out?".localized(language)),
                primaryButton: .destructive(Text("Yes".localized(language))) {
                    // Действие выхода
                },
                secondaryButton: .cancel(Text("Cancel".localized(language)))
            )
        }
        .navigationBarHidden(true)
        .background(.background)
        .ignoresSafeArea()
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(router: StartRouter())
        }
    }
}
