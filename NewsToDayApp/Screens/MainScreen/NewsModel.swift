//
//  NewsModel.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 23.10.2024.
//

import SwiftUI

struct News: Identifiable { // in Model File
    var id = UUID()
    var name: String
    var bookmark: Bool
    var image: Image
    var category: String
    var author: String
    var description: String
}
