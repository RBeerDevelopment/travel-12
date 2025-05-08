//
//  SignUpView.swift
//  OnTime
//
//  Created by Robin Beer on 15.01.25.
//

import Clerk
import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var code = ""
    @State private var isInVerificationStep = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @Environment(Clerk.self) private var clerk
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Form {
                if isInVerificationStep {
                    verificationSection
                } else {
                    signupSection
                }
                    
                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle(isInVerificationStep ? "Verify Email" : "Log In")
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    LoadingIndicator()
                }
            }
            .onSubmit {
                handleSubmit()
            }
            if(isInVerificationStep) {
                Button(action: {
                    isInVerificationStep = false
                    password = ""
                }) {
                    Text("Cancel")
                        .padding(.horizontal)
                }
            } else {
                Spacer()
                Spacer()
                SignInWithAppleView()
                    .frame(width: 200, height: 48)
            }
        }
    }
    
    private var signupSection: some View {
        Section {
            TextField("Email", text: $email)
                .textContentType(.username)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .textContentType(.password)
            Button(action: {
                Task {
                    isLoading = true
                    await signUp(email: email, password: password)
                    isLoading = false
                }
            }) {
                HStack {
                    Text("Login")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
            }
            .disabled(email.isEmpty || password.count < 8)
        } footer: {
            Text("We'll send you a verification code to confirm your email address.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
    
    private var verificationSection: some View {
        Section {
            TextField("Verification Code", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
            
            Button(action: {
                Task {
                    isLoading = true
                    await verify(code: code)
                    isLoading = false
                }
            }) {
                HStack {
                    Text("Verify Email")
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
            .disabled(code.isEmpty)
        } footer: {
            Text("Enter the verification code we sent to \(email)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

extension SignUpView {
    
    func handleSubmit() {
        Task {
            isLoading = true
            await signUp(email: email, password: password)
            isLoading = false
        }
    }
    
    func signUp(email: String, password: String) async {
        do {
            let signUp = try await SignUp.create(
                strategy: .standard(emailAddress: email.lowercased(), password: password)
            )
            
            try await signUp.prepareVerification(strategy: .emailCode)
            errorMessage = nil
            isInVerificationStep = true
        } catch {
            dump(error)
            let clerkError = error as! ClerkAPIError
            
            if(clerkError.code == "form_identifier_exists" && ((clerkError.message?.contains("That email address is taken")) != nil)) {
                do {
                    try await SignIn.create(
                        strategy: .identifier(email, password: password)
                    )
                } catch {
                    dump(error)
                    errorMessage = "Email exists, but could not login. Try again"
                }
            } else {
                errorMessage = error.localizedDescription
                dump(error)
            }
        }
    }
    
    func verify(code: String) async {
        do {
            guard let signUp = clerk.client?.signUp else {
                errorMessage = "Session expired. Please try again."
                isInVerificationStep = false
                return
            }
            
            try await signUp.attemptVerification(strategy: .emailCode(code: code))
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            dump(error)
        }
    }
}

#Preview {
    SignUpView()
}
