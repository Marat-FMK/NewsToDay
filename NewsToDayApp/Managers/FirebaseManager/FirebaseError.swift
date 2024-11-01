//
//  FireStoreError.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 30.10.2024.
//

import Foundation

enum FirebaseError: LocalizedError {
    case authenticationFailed
    case missingDocument
    case missingField(fieldName: String)
    case unspecifiedError(description: String = "Произошла неизвестная ошибка.")
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed:
            return "Ошибка аутентификации: пользователь не найден или не авторизован."
        case .missingDocument:
            return "Запрашиваемый документ не найден в базе данных."
        case .missingField(let nameField):
            return "Поле '\(nameField)' отсутствует в документе."
        case .unspecifiedError(let description):
            return description
        }
    }
}
