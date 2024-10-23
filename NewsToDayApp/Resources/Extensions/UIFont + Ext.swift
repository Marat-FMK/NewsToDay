//
//  File.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 23.10.2024.
//

import SwiftUI

extension Font {
    static func interMedium(_ size: CGFloat) -> Font? {
        return Font.custom("Inter-Medium", size: size)
    }

    static func interRegular(_ size: CGFloat) -> Font? {
        return Font.custom("Inter-Regular", size: size)
    }

    static func interSemiBold(_ size: CGFloat) -> Font? {
        return Font.custom("Inter-SemiBold", size: size)
    }
}
