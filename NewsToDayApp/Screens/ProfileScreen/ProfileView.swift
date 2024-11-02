//
//  ProfileView.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Properties
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    
    @StateObject private var viewModel: ProfileViewModel
    @State private var showAlert = false
    @State private var isChangeUserPhoto = false
    @State private var isShowingTermsConditionsScreen = false
    @State private var isShowingLanguageScreen = false
    
    // MARK: - Initialization
    
    init(router: StartRouter) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(router: router))
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                ProfileTitle(
                    title: "Profile".localized(language),
                    type: .withoutBackButton
                )
                .padding(.top, Drawing.titleTopPadding)
                .padding(.horizontal, Drawing.horizontalPadding)
                
                ProfileHeaderView(
                    avatar: Image(viewModel.selectedAvatar),
                    userName: viewModel.userName,
                    email: viewModel.userEmail,
                    changeAvatar: {
                        isChangeUserPhoto.toggle()
                    }
                )
                .padding(Drawing.headerPadding)
                // Theme Selection Segmented Control
                Picker("", selection: $themeManager.userTheme) {
                    Text("System").tag(ThemeMode.system)
                    Text("Dark").tag(ThemeMode.dark)
                    Text("Light").tag(ThemeMode.light)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, Drawing.horizontalPadding)
                NavigationLink(destination: LanguageScreen(), isActive: $isShowingLanguageScreen) {
                    CustomButton(
                        title: "Language",
                        imageName: nil,
                        action: { isShowingLanguageScreen = true },
                        buttonType: .language,
                        isSelected: false
                    )
                    .padding(Drawing.horizontalPadding)
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
                    .padding(.horizontal, Drawing.horizontalPadding)
                    .padding(.bottom, Drawing.bottomPadding)
                }
                
                CustomButton(
                    title: "Sign Out".localized(language),
                    action: {
                        showAlert = true
                    },
                    buttonType: .profile,
                    isSelected: false
                )
                .padding(Drawing.horizontalPadding)
                
                Spacer()
            }
            .task {
                viewModel.fetchUserData()
            }
            .padding(.bottom, Drawing.bottomPadding)
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
            .background(Color.white)
            .blur(radius: isChangeUserPhoto ? Drawing.blurRadius : 0)
            .ignoresSafeArea()
            
            if isChangeUserPhoto {
                // Tapping outside ChangePhotoView will toggle isChangeUserPhoto
                Color.clear
                    .contentShape(Rectangle()) // Enables taps outside the view area
                    .onTapGesture {
                        isChangeUserPhoto = false
                    }
                
                ChangePhotoView(onAvatarSelected: { avatar in
                    viewModel.setUserAvatar(avatar)
                    isChangeUserPhoto = false
                })
                .frame(height: Drawing.changePhotoViewHeight)
            }
        }
    }
    // MARK: - Constants
    private enum Drawing {
        static let titleTopPadding: CGFloat = 68
        static let horizontalPadding: CGFloat = 20
        static let headerPadding: CGFloat = 20
        static let bottomPadding: CGFloat = 20
        static let blurRadius: CGFloat = 5
        static let changePhotoViewHeight: CGFloat = 300
    }
}


// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(router: StartRouter())
        }
    }
}
