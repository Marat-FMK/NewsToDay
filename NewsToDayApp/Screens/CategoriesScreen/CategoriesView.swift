//
//  CategoriesView.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct CategoriesView: View {
    var body: some View {
        ZStack {
            Text("Hello, World!")
        }
        .background(DS.Colors.purpleLighter)
        .ignoresSafeArea()
       
        .toolbar {
            CustomToolBar(
                title: Resources.Text.categoriesTitle,
                subTitle: Resources.Text.categoriesSubTitle
            )
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoriesView()
        }
    }
}
