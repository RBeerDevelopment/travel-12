//
//  StationSearchView.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import SwiftUI
import SwiftData

struct StationSearchView: View {
    
    @EnvironmentObject var stationViewModel: StationViewModel
    @State var isSearchActive: Bool = false
    
    var searchedStations: [StationSearchItem] {
        stationViewModel.stations
    }
    
    var recentAndNearbyStations: [StationSearchItem] {
        let combinedArray = stationViewModel.nearbyStation + stationViewModel.recentlySearchedStations
        let deduplicatedStations = Set(combinedArray).sorted(by: { ($0.distanceToUser ?? .infinity) < ($1.distanceToUser ?? .infinity) })
        return  deduplicatedStations
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                if(searchedStations.isEmpty && !stationViewModel.searchQuery.isEmpty) {
                    Text("No stations found")
                }
                if(!isSearchActive) {
                    RecentAndNearbyStationsListView(recentAndNearbyStations: recentAndNearbyStations)
                } else {
                    ForEach(searchedStations.indices, id: \.self) { idx in
                        SearchItemView(station: searchedStations[idx])
                        if(idx != searchedStations.count - 1) {
                            Divider()
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .background(Color(.systemGroupedBackground))
            .padding()
        }
        .searchable(text: $stationViewModel.searchQuery,
            isPresented: $isSearchActive, prompt: "Station Search")
        
    }
}
