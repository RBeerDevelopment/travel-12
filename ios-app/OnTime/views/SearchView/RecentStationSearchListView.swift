//
//  RecentStationSearchListView.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 10.05.25.
//

import SwiftUI
import SwiftData

struct RecentStationSearchListView: View {
    
    @Query(sort: \RecentSearchStation.lastSearched, order: .reverse) var recentlySearchedStations: [RecentSearchStation]
    
    var body: some View {
        
        if(recentlySearchedStations.isEmpty) {
            Text("Your recent searches will appear here.")
        } else {
            VStack(alignment: .leading) {
                Text("Recent Searches")
                    .font(.title3)
                ForEach(recentlySearchedStations.indices, id: \.self) { idx in
                    SearchItemView(station:
                                    StationSearchItem(snapshot: recentlySearchedStations[idx].stationSnapshot))
                    if(idx != recentlySearchedStations.count - 1) {
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview {
    RecentStationSearchListView()
}
