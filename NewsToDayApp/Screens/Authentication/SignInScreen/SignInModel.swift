//
//  SignInModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

class SignInModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}
