//
//  SignInOrSignUpView.swift
//  OnTime
//
//  Created by Robin Beer on 15.01.25.
//

import SwiftUI

struct SignInOrSignUpView: View {

    var body: some View {
        NavigationView {
            VStack {
                SignUpView()
            }.frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    SignInOrSignUpView()
}
