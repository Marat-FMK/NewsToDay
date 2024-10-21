//
//  DS.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 21.10.2024.
//
import SwiftUI

// MARK: - DS (Design System)
enum DS {
    /// Палитра цветов NewsToDay
    enum Colors {
        /// Белый акцентный цвет.
        static let whiteAccent = Color(hex: "#FFFFFF")
        /// Индиговый акцентный цвет.
        public static let indigoAccent = Color(hex: "#475AD7")
        /// Основной цвет текста.
        public static let primaryText = Color(hex: "#333647")
        /// Второстепенный цвет текста.
        public static let secondaryText = Color(hex: "#7C82A1")
        public static let grayLight = Color(hex: "#ACAFC3")
        /// Цвет текста кнопки.
        public static let buttonText = Color(hex: "#666C8E")
        /// Цвет фона кнопки.
        public static let buttonBackground = Color(hex: "#13353F2B")
    }
}
