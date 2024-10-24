//
//  ProfileView.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            CustomToolBar(
                title: Resources.Text.profileTitle,
                subTitle: ""
            )
            .padding(.top, 0)
            Spacer()
            Text("Hello, World!")
        }

        .navigationBarHidden(true)
        .background(.background)
        .ignoresSafeArea()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
