//
//  SignUpScreen.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

struct SignUpScreen: View {
    @StateObject private var signInModel = SignInModel()
   
    var body: some View {
        VStack {
            CustomToolBar(title: "Welcome Back 👋", subTitle: "I am happy to see you again. You can continue where you left off by logging in")
            
            CustomTextField(image: "person", placeHolder: "Email Adress", text: $signInModel.email)
                .padding(.horizontal, 20)
                .padding(.top, 32)
            
            CustomTextField(image: "mail", placeHolder: "Password", text: $signInModel.password)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            CustomTextField(image: "lock", placeHolder: "Password", text: $signInModel.password)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            CustomTextField(image: "lock", placeHolder: "Password", text: $signInModel.password)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            CustomButton(title: "Sign In", action: {
                
            }, buttonType: .mode, isSelected: true)
            .padding(.horizontal, 25)
            .padding(.top, 16)
        
            Spacer()
            
        }
        .navigationBarHidden(true)
        .background(.background)
        .ignoresSafeArea()
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
      SignUpScreen()
    }
}
