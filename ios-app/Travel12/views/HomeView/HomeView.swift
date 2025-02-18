//
//  ContentView.swift
//  Travel12
//
//  Created by Robin Beer on 27.06.24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var stationViewModel: StationViewModel

    @Environment(\.modelContext) private var modelContext

    @State private var isSearchActive = false

    @State private var showProfileSheet = false

    init() {
        let locationManager = LocationManager()
        _locationManager = StateObject(wrappedValue: locationManager)
        _stationViewModel = StateObject(wrappedValue: StationViewModel(locationManager: locationManager))
    }

    var body: some View {
        NavigationView {
            VStack {
                if isSearchActive {
                    StationSearchView(stations: stationViewModel.stations, isQueryEmpty: stationViewModel.searchQuery.isEmpty)
                } else {
                    FavoriteDeparturesView()
                }
            }
            
            .navigationTitle("Travel 12")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showProfileSheet = true
                    }) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                            .foregroundStyle(.primary)
                    }
                }
            }
            .padding()
            .background(!isSearchActive ? Color(.systemGroupedBackground).ignoresSafeArea() : Color.clear.ignoresSafeArea())

        }
        
        .searchable(text: $stationViewModel.searchQuery, isPresented: $isSearchActive, prompt: "Station Search")
        .onAppear {
            locationManager.startUpdatingLocation()
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
        .sheet(isPresented: $showProfileSheet) {
            ProfileView()
        }
    }
        
}

#Preview {
    HomeView()
}
