//
//  CustomButton.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 21.10.2024.
//

import SwiftUI

// MARK: - CustomButton View
struct CustomButton: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    // MARK: - ButtonType Enum
    // Defines the types of buttons that can be created.
    enum ButtonType {
        case profile, language, mode
    }
    
    // MARK: - Drawing Constants
    // Constants related to the button's appearance.
    private enum Drawing {
        static let cornerRadius: CGFloat = 12
    }
    
    // MARK: - Properties
    let title: String
    var imageName: String?  // Optional image name for the button
    let action: () -> Void  // Action closure triggered on button tap
    let buttonType: ButtonType  // Type of button (profile, language, mode)
    let isSelected: Bool  // Whether the button is in a selected state
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack {
                // MARK: - Button Title
                Text(title.localized(language))
                Spacer()
                
                // MARK: - Button Image Handling
                if buttonType == .profile {
                    Image(systemName: imageName ?? "chevron.right")
                } else {
                    if isSelected {
                        Image(systemName: "checkmark")
                    } else {
                        Text("")
                    }
                }
            }
            .padding()
            // MARK: - Button Text and Background Color Handling
            .foregroundStyle(isSelected
                             ? DS.Colors.purpleLighter
                             : DS.Colors.grayDark
            )
            .background(isSelected
                        ? DS.Colors.purplePrimary
                        : DS.Colors.grayLighter
                        )
            .clipShape(RoundedRectangle(cornerRadius: Drawing.cornerRadius))
        }
    }
}

// MARK: - Preview
//#Preview {
//    CustomButton(title: "Language", action: {}, buttonType: .mode, isSelected: true)
//}
