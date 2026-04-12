//
//  ActiveStationSearchView.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 06.04.26.
//

import SwiftUI
import SwiftData

struct ActiveStationSearchView: View {
    
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
        return Text("Test")
    }
}
