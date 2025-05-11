//
//  OnTimeApp.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//

import SwiftUI
import SwiftData
import Clerk
import Combine

@main
struct OnTimeApp: App {
    
    @State private var clerk = Clerk.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                if clerk.isLoaded == false {
                    LargeLoadingIndicator()
                } else if clerk.user == nil {
                    SignInOrSignUpView()
                } else {
                    TabWrapperView()
                }
            }
            .environment(clerk)
            .modelContainer(for: [FavoriteTrip.self, RecentSearchStation.self])
            .task {
                clerk.configure(publishableKey: "pk_test_YXNzdXJlZC13cmVuLTcxLmNsZXJrLmFjY291bnRzLmRldiQ")
                try? await clerk.load()
            }
        }
    }
}
