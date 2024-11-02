//
//  ProfileHeaderView.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 23.10.2024.
//

import SwiftUI

struct ProfileHeaderView: View {
    var avatar: Image
    var userName: String
    var email: String
    var changeAvatar: () -> Void

    private enum Drawing {
        static let frameImage: CGFloat = 72
        static let spacing: CGFloat = 5
    }

    var body: some View {
        HStack {
            avatar
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 72, height: 72)
                .clipShape(Circle())
                .onTapGesture {
                    changeAvatar()
                }

            VStack(alignment: .leading, spacing: 5) {
                Text(userName)
                    .font(.headline)

                Text(email)
                    .font(.subheadline)
                    .foregroundColor(DS.Colors.grayPrimary)
            }
            .padding()
        }
    }
}

//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileHeaderView(avatar: Image("chinatown"), userName: "sss", email: "sdsdasdasd")
//    }
//}

