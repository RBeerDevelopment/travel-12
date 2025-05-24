//
//  OnTimeApp.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//

import SwiftUI
import SwiftData
import Clerk
import Toasts

@main
struct OnTimeApp: App {
    
    @State private var clerk = Clerk.shared
    
    @State private var modelContainer: ModelContainer
    
    init() {
        modelContainer = try! ModelContainer(for: FavoriteTrip.self, RecentSearchStation.self)
        FavoritesManager.configure(context: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(clerk)
                .task {
                    clerk.configure(publishableKey: "pk_test_YXNzdXJlZC13cmVuLTcxLmNsZXJrLmFjY291bnRzLmRldiQ")
                    try? await clerk.load()
                }
                .installToast(position: .bottom)
        }
        
        .modelContainer(modelContainer)
        
    }
}

struct AppView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Clerk.self) private var clerk
    
    var body: some View {
        ZStack {
            if clerk.isLoaded == false {
                LargeLoadingIndicator()
            } else if clerk.user == nil {
                SignInOrSignUpView()
            } else {
                TabWrapperView(modelContext: modelContext)
            }
        }
    }
}
