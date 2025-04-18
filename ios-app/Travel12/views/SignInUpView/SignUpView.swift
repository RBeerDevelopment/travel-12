//
//  SignUpView.swift
//  Travel12
//
//  Created by Robin Beer on 15.01.25.
//

import ClerkSDK
import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var code = ""
    @State private var isVerifying = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Form {
                if isVerifying {
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
            .navigationTitle(isVerifying ? "Verify Email" : "Sign Up")
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    LoadingIndicator()
                }
            }
            .onSubmit {
                handleSubmit()
            }
            Button(action: {
                handleSubmit()
            }) {
                HStack {
                    Text("Continue").padding(.trailing, 6)
                    Image(systemName: "arrow.right")
                }
                .padding(.horizontal)
            }
            .disabled(email.isEmpty || password.isEmpty)
            
            Spacer()
        }
    }
    
    private var signupSection: some View {
        Section {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                
            SecureField("Password", text: $password)
                .textContentType(.newPassword)
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
                strategy: .standard(emailAddress: email, password: password)
            )
            
            try await signUp.prepareVerification(strategy: .emailCode)
            errorMessage = nil
            isVerifying = true
        } catch {
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
            guard let signUp = Clerk.shared.client?.signUp else {
                errorMessage = "Session expired. Please try again."
                isVerifying = false
                return
            }
            
            try await signUp.attemptVerification(.emailCode(code: code))
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
