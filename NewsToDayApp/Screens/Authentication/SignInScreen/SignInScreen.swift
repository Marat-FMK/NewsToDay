//
//  SignInScreen.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

struct SignInScreen: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showSignUp = false
    
    var body: some View {
        VStack {
            CustomToolBar(title: "Welcome Back 👋", subTitle: "I am happy to see you again. You can continue where you left off by logging in.")
            
            CustomTextField(image: "mail", placeHolder: "Email Address", text: $viewModel.email)
                .padding(.horizontal, 20)
                .padding(.top, 32)
            
            CustomTextField(image: "lock", placeHolder: "Password", text: $viewModel.password)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            CustomButton(title: "Sign In", action: {
                print("pressed signIn")
                viewModel.signIn()
            }, buttonType: .mode, isSelected: viewModel.formIsValid)
            .padding(.horizontal, 25)
            .padding(.top, 64)
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
            
            Spacer()
            
            AuthTextButton(title: "Don't have an account?", sign: "Sign Up", action: {
                showSignUp.toggle()
            })
            .padding(.bottom, 44)
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
}


struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AuthViewModel() // Создаем пример viewModel
              SignInScreen(viewModel: viewModel)
                  .previewDevice("iPhone 14") // Указываем устройство для превью
    }
}



