//
//  StationSearchView.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import SwiftUI
import SwiftData

struct StationSearchView: View {
    
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var stationViewModel: StationViewModel
    
    @State private var selectedStation: StationSearchItem? = nil
    @State private var isShowingDepartures = false
    
    @State private var isSearchPresented = false

    var recentAndNearbyStations: [StationSearchItem] {
        let combinedArray = stationViewModel.nearbyStation + stationViewModel.recentlySearchedStations
        let deduplicatedStations = Set(combinedArray).sorted(by: { ($0.distanceToUser ?? .infinity) < ($1.distanceToUser ?? .infinity) })
        return deduplicatedStations
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if(isSearchPresented) {
                    ActiveStationSearchView()
                } else {
                    InactiveStationSearchView()
                }
            }
//            .navigationDestination(isPresented: $isShowingDepartures) {
//                if let station = selectedStation {
//                    DeparturesView(stationId: station.id.components(separatedBy: ":")[2], stationName: station.name, clean)
//                }
//            }
            .addToastSafeAreaObserver()
        }
        .searchable(text: $stationViewModel.searchQuery, isPresented: $isSearchPresented)
    }
}
