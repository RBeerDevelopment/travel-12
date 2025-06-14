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

//    var recentAndNearbyStations: [StationSearchItem] {
//        let combinedArray = stationViewModel.nearbyStation + stationViewModel.recentlySearchedStations
//        let deduplicatedStations = Set(combinedArray).sorted(by: { ($0.distanceToUser ?? .infinity) < ($1.distanceToUser ?? .infinity) })
//        return  deduplicatedStations
//    }
    
    var body: some View {
        
        let stationsToShow = stationViewModel.stations.isEmpty ? stationViewModel.nearbyStation : stationViewModel.stations
        NavigationStack {
            List(stationsToShow) { station in
                Button {
                    selectedStation = station
                    isShowingDepartures = true
                    handleStationClick(station, context: modelContext)
                } label: {
                    SearchItemView(station: station)
                }
            }
            .navigationTitle("Search")
            .addToastSafeAreaObserver()
            .navigationDestination(isPresented: $isShowingDepartures) {
                if let station = selectedStation {
                    DeparturesView(stationId: station.id.components(separatedBy: ":")[2], stationName: station.name)
                }
            }
        }
    }
}
