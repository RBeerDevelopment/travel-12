//
//  ContentView.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    var body: some View {
        NavigationStack {
            FavoriteDeparturesView()
                .navigationTitle("Favorites")
                .addToastSafeAreaObserver()
        }
    }
        
}

#Preview {
    let container = try! ModelContainer(
        for: FavoriteTrip.self, RecentSearchStation.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    context.insert(FavoriteTrip(
        lineId: "U5",
        stationId: "900120009",
        destinationId: "Hönow",
        stationName: "Alexanderplatz"
    ))
    context.insert(FavoriteTrip(
        lineId: "U5",
        stationId: "900120009",
        destinationId: "Hönow",
        stationName: "Alexanderplatz"
    ))
    
    return FavoritesView()
        .modelContainer(container)
}
