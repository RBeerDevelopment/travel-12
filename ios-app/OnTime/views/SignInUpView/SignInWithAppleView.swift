//
//  SignInWithAppleView.swift
//  OnTime
//
//  Created by Robin Beer on 17.01.25.
//

import AuthenticationServices
import Clerk
import SwiftUI

struct SignInWithAppleView: View {
    
    @Environment(Clerk.self) private var clerk
    
    var body: some View {
        // Use Apple's built-in SignInWithAppleButton
        SignInWithAppleButton { request in
          request.requestedScopes = [.email, .fullName]
          request.nonce = UUID().uuidString // Setting the nonce is mandatory
        } onCompletion: { result in
          Task {
            // Access the Apple ID Credential
            guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential else {
              dump("Unable to get credential of type ASAuthorizationAppleIDCredential")
              return
            }

            // Access the necessary identity token on the Apple ID Credential
            guard let idToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else {
              dump("Unable to get ID token from Apple ID Credential.")
              return
            }

            // Authenticate with Clerk
              _ = try await SignIn.authenticateWithIdToken(provider: .apple, idToken: idToken)
          }
        }
      }
}

#Preview {
    SignInWithAppleView()
}
