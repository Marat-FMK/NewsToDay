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
    @State private var isChangeUserPhoto = false
    @State private var isShowingTermsConditionsScreen = false
    @State private var isShowingLanguageScreen = false
    

    
    init(router: StartRouter) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(router: router))
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                ProfileTitle(
                    title: "Profile".localized(language),
                    type: .withoutBackButton
                )
                .padding(.top, 68)
                .padding(.horizontal, 20)
                
                ProfileHeaderView(
                    avatar: Image(viewModel.selectedAvatar),
                    userName: viewModel.userName,
                    email: viewModel.userEmail,
                    changeAvatar: {
                        isChangeUserPhoto.toggle()
                    }
                )
                .padding(20)
                
                
                
                NavigationLink(destination: LanguageScreen(), isActive: $isShowingLanguageScreen) {
                    CustomButton(
                        title: "Language",
                        imageName: nil,
                        action: { isShowingLanguageScreen = true },
                        buttonType: .language,
                        isSelected: false
                    )
                    .padding(20)
                }
                
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
                    },
                    buttonType: .profile,
                    isSelected: false
                )
                .padding(20)
                
                Spacer()
            }
            .task {
                viewModel.fetchUserData()
            }
            .padding(.bottom, 20)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Are you sure you want to sign out?".localized(language)),
                    primaryButton: .destructive(Text("Yes".localized(language))) {
                        Task {
                            await viewModel.logOut()
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel".localized(language)))
                )
            }
            
            .navigationBarHidden(true)
            .background(.background)
            .blur(radius: isChangeUserPhoto ? 5 : 0)
            .ignoresSafeArea()
            if isChangeUserPhoto {
                ChangePhotoView(onAvatarSelected: { avatar in
                    viewModel.selectedAvatar = avatar
                    isChangeUserPhoto = false
                })
                .frame(height: 300)
            }
        }
        
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(router: StartRouter())
        }
    }
}
