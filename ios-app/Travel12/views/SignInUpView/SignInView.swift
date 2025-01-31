//
//  SignInView.swift
//  Travel12
//
//  Created by Robin Beer on 15.01.25.
//

import ClerkSDK
import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Sign In")
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    LoadingIndicator()
                }
            }
            Spacer()
            Button(action: {
                Task {
                    isLoading = true
                    await submit(email: email, password: password)
                    isLoading = false
                }
            }) {
                HStack {
                    Text("Sign In").padding(.trailing, 6)
                    Image(systemName: "arrow.right")
                }
                .padding(.horizontal)
            }
            .disabled(email.isEmpty || password.isEmpty || isLoading)
        }
    }
}

extension SignInView {
    func submit(email: String, password: String) async {
        do {
            try await SignIn.create(
                strategy: .identifier(email, password: password)
            )
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            dump(error)
        }
    }
}

#Preview {
    SignInView()
}
