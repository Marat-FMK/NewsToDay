//
//  SignUpScreen.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

struct SignUpScreen: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    @ObservedObject var viewModel: AuthViewModel
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            CustomToolBar(
                title: "Create Account".localized(language),
                subTitle: "Please fill in your details".localized(language)
            )
            
            CustomTextField(
                image: "person",
                placeHolder: "Username".localized(language),
                text: $viewModel.userName
            )
            .padding(.horizontal, 20)
            .padding(.top, 32)
            
            CustomTextField(
                image: "mail",
                placeHolder: "Email Address".localized(language),
                text: $viewModel.email
            )
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            CustomTextField(
                image: "lock",
                placeHolder: "Password".localized(language),
                text: $viewModel.password
            )
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            CustomTextField(
                image: "lock",
                placeHolder: "Repeat Password".localized(language),
                text: $viewModel.reEnterPassword
            )
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            Button(action: {
                viewModel.signUp()
            }) {
                Text("Sign Up".localized(language))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.signUpFormIsValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 25)
            .padding(.top, 16)
            .disabled(!viewModel.signUpFormIsValid)
            
            Spacer()
            
            AuthTextButton(
                title: "Already have an account?".localized(language),
                sign: "Sign In".localized(language),
                action: {
                    onDismiss()
                })
            .padding(.bottom, 44)
        }
        .navigationBarHidden(true)
        .background(Color(.systemBackground))
        .ignoresSafeArea()
        .alert(isPresented: isPresentedAlert()) {
            Alert(
                title: Text(viewModel.authError == .signUpSuccess ? "Success" : "Error"),
                message: Text(viewModel.authError?.localizedDescription ?? ""),
                dismissButton: .default(Text("OK"), action: {
                    if viewModel.authError == .signUpSuccess {
                        viewModel.cancelErrorAlert()
                        onDismiss()
                    } else {
                        viewModel.cancelErrorAlert()
                    }
                })
            )
        }
    }
    
    private func isPresentedAlert() -> Binding<Bool> {
        Binding(get: { viewModel.authError != nil },
                set: { isPresenting in
            if isPresenting { return }
        })
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AuthViewModel(router: StartRouter()) // Создаем пример viewModel
        SignUpScreen(viewModel: viewModel, onDismiss: { })
            .previewDevice("iPhone 14")
    }
}
