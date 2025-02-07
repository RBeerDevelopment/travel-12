//
//  LogoutView.swift
//  Travel12
//
//  Created by Robin Beer on 10.11.24.
//

import SwiftUI
import ClerkSDK

struct ProfileView: View {
    
    @State private var clerk = Clerk.shared
    
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
            if let name = clerk.user?.fullName {
                Text(name)
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
