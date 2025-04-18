//
//  SignInOrSignUpView.swift
//  Travel12
//
//  Created by Robin Beer on 15.01.25.
//

import SwiftUI

struct SignInOrSignUpView: View {
    @State private var isSignUp = true

    var body: some View {
        NavigationView {
            VStack {
                if isSignUp {
                    SignUpView()
                } else {
                    SignInView()
                }

//                SignInWithAppleView()
//                    .padding()

                Button {
                    isSignUp.toggle()
                } label: {
                    if isSignUp {
                        Text("Already have an account? Sign In")
                    } else {
                        Text("Don't have an account? Sign Up")
                    }
                }
                .padding()
            }.frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    SignInOrSignUpView()
}
