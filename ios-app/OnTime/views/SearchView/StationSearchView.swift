//
//  StationSearchView.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import SwiftUI
import SwiftData

struct StationSearchView: View {
    
    var stations: [StationSearchItem]
    let isQueryEmpty: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if(stations.isEmpty && !isQueryEmpty) {
                Text("No stations found")
            }
            if(stations.count == 0) {
                RecentStationSearchListView()
            } else {
                ForEach(stations.indices, id: \.self) { idx in
                    SearchItemView(station: stations[idx])
                    if(idx != stations.count - 1) {
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview {
    StationSearchView(stations: demoStations, isQueryEmpty: false)
}
