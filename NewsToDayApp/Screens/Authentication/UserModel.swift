//
//  UserModel.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct UserModel: Identifiable, Codable {
    let id: String
    var userName: String
    var email: String
    var userPhotoData: Data?
    
    // Создание SwiftUI Image из Data
    var userPhoto: Image? {
        guard let data = userPhotoData,
              let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
    
    // Получение инициалов пользователя
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: userName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
