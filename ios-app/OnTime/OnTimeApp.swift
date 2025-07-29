//
//  OnTimeApp.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//

import SwiftUI
import SwiftData
import Toasts

@main
struct OnTimeApp: App {
    @State private var modelContainer: ModelContainer
    
    init() {
        modelContainer = try! ModelContainer(for: FavoriteTrip.self, RecentSearchStation.self)
        FavoritesManager.configure(context: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .installToast(position: .bottom)
        }
        
        .modelContainer(modelContainer)
        
    }
}

struct AppView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabWrapperView(modelContext: modelContext)
    }
}
