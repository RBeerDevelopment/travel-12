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
            Text("Are you sure you want to log out?").font(.headline)
                .padding(.bottom, 20)
            Button("Sign Out") {
              Task { try? await clerk.signOut() }
            }
            .font(.headline)
            .foregroundColor(.red)
            .padding()
        }
        .padding()
    }
}
