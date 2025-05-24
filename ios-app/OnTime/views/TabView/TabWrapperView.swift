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
            StationSearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
            NavView()
                .tabItem {
                    Label("Navigation", systemImage: "arrow.trianglehead.turn.up.right.circle")
                }
        }
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

