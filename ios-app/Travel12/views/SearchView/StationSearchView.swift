//
//  StationSearchView.swift
//  Travel12
//
//  Created by Robin Beer on 28.06.24.
//

import SwiftUI

struct StationSearchView: View {
    
    var stations: [StationSearchItem]
    let isQueryEmpty: Bool
    
    var body: some View {
        ScrollView {
            if(stations.count == 0) {
                Text(isQueryEmpty ? "Enter a search query" :"No stations found")
            } else {
                ForEach(stations) { station in
                    SearchItemView(station: station)
                    Divider()
                }
            }
        }
    }
}

#Preview {
    StationSearchView(stations: demoStations, isQueryEmpty: false)
}
