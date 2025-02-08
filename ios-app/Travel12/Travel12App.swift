//
//  Travel12App.swift
//  Travel12
//
//  Created by Robin Beer on 27.06.24.
//

import SwiftUI
import SwiftData
import ClerkSDK
import Combine

@main
struct Travel12App: App {
    
    @State private var clerk = Clerk.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                if clerk.loadingState == .notLoaded {
                    LoadingIndicator()
                } else if clerk.user == nil {
                    SignInOrSignUpView()
                } else {
                    HomeView()
                        .modelContainer(for: FavoriteTrip.self)
                }
            }
            .task {
                clerk.configure(publishableKey: "pk_test_YXNzdXJlZC13cmVuLTcxLmNsZXJrLmFjY291bnRzLmRldiQ")
                try? await clerk.load()
            }
        }
    }
}
