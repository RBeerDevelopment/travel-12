//
//  LogoutView.swift
//  OnTime
//
//  Created by Robin Beer on 10.11.24.
//

import SwiftUI
import Clerk

struct ProfileView: View {
    
    @Environment(Clerk.self) private var clerk
    
    var body: some View {
        VStack {
            Text("Profile").font(.headline)
            Spacer()
            if let profileImageURL = clerk.user?.imageUrl {
                AsyncImage(url: URL(string: profileImageURL))
                    .frame(width: 80, height: 80)
                    .padding()
                    .clipShape(Circle())
            }
            if let firstName = clerk.user?.lastName, let lastName = clerk.user?.lastName {
                Text("\(firstName) \(lastName)")
            }
            if let emailAddress = clerk.user?.emailAddresses.first {
                Text(emailAddress.emailAddress)
            }
            Spacer()
            Text("Want to log out?").font(.headline)
                .padding(.bottom, 12)
            Button("Sign Out") {
              Task { try? await clerk.signOut() }
            }
            .font(.headline)
            .foregroundColor(.red)
            .padding(.bottom)
        }
        .padding()
    }
}
