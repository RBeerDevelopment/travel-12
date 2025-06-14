//
//  TabView.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 01.05.25.
//

import SwiftUI
import SwiftData

struct TabWrapperView: View {
    
    @StateObject private var locationManager: LocationManager
    @StateObject private var stationViewModel: StationViewModel
    
    init(modelContext: ModelContext) {
        let locationManager = LocationManager()
        _locationManager = StateObject(wrappedValue: locationManager)
        _stationViewModel = StateObject(wrappedValue: StationViewModel(locationManager: locationManager, context: modelContext))
    }
    
    var body: some View {
        TabView {
            Tab("Favorites", systemImage: "star") {
                FavoritesView()
            }
            Tab("Navigation", systemImage: "arrow.trianglehead.turn.up.right.circle") {
                NavView()
            }
            Tab(role: .search) {
                StationSearchView()
            }
        }
        .searchable(text: $stationViewModel.searchQuery)
        .onAppear {
            locationManager.startUpdatingLocation()
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
        .environmentObject(locationManager)
        .environmentObject(stationViewModel)
    }
}

