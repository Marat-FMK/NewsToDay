//
//  SignInScreen.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

struct SignInScreen: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language

    @StateObject var viewModel: AuthViewModel
    
    @State private var showSignUp = false
    
    init(router: StartRouter) {
        self._viewModel = StateObject(
            wrappedValue: AuthViewModel(router: router)
       )
    }
    
    var body: some View {
        VStack {
            CustomToolBar(
                title: "Welcome Back".localized(language) + "👋",
                subTitle: "I am happy to see you again. You can continue where you left off by logging in.".localized(language)
            )
            
            CustomTextField(
                image: "mail",
                placeHolder: "Email Address".localized(language),
                text: $viewModel.email
            )
                .padding(.horizontal, 20)
                .padding(.top, 32)
            
            CustomTextField(
                image: "lock",
                placeHolder: "Password".localized(language),
                text: $viewModel.password
            )
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            CustomButton(
                title: "Sign In".localized(language),
                action: {
                viewModel.signIn()
            },
                buttonType: .mode,
                isSelected: viewModel.formIsValid
            )
            .padding(.horizontal, 25)
            .padding(.top, 64)
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
            
            Spacer()
            
            AuthTextButton(
                title: "Don't have an account?".localized(language),
                sign: "Sign Up".localized(language),
                action: {
                showSignUp.toggle()
            })
            .padding(.bottom, 44)
        }
        .alert(isPresented: isPresentedAlert()) {
            Alert(
                title: Text(Resources.Text.error.localized(language)),
                message: Text(viewModel.authError?.localizedDescription ?? "" ),
                dismissButton: .default(Text(Resources.Text.ok.localized(language)),
                                        action: viewModel.cancelErrorAlert)
            )
        }
        .navigationBarHidden(true)
        .background(Color(.systemBackground))
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpScreen(viewModel: viewModel, onDismiss: {
                showSignUp = false
            })
        }
    }
    
    private func isPresentedAlert() -> Binding<Bool> {
        Binding(get: { viewModel.authError != nil },
                set: { isPresenting in
            if isPresenting { return }
        }
        )
    }
}


struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen(router: StartRouter())
                  .previewDevice("iPhone 14")
    }
}



