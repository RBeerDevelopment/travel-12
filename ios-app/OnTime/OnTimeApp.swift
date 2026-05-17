//
//  OnTimeApp.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//

import SwiftUI
import Sentry

import SwiftData
import Toasts

@main
struct OnTimeApp: App {
    @State private var modelContainer: ModelContainer
    
    init() {
        SentrySDK.start { options in
            options.dsn = Bundle.main.object(forInfoDictionaryKey: "SentryDSN") as? String

            // Adds IP for users.
            // For more information, visit: https://docs.sentry.io/platforms/apple/data-management/data-collected/
            options.sendDefaultPii = true

            options.tracesSampleRate = 0

            // Configure profiling. Visit https://docs.sentry.io/platforms/apple/profiling/ to learn more.
            options.configureProfiling = {
                $0.sessionSampleRate = 1.0 // We recommend adjusting this value in production.
                $0.lifecycle = .trace
            }

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
            
            // Enable experimental logging features
            options.experimental.enableLogs = true
        }

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
