//
//  ProfileView.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Text("Hello, World!")
            
        }
        .toolbar {
            CustomToolBar(
                title: Resources.Text.profileTitle,
                subTitle: ""
            )
        }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
