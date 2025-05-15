//
//  NearbyStationListView.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 11.05.25.
//

import SwiftUI

struct RecentAndNearbyStationsListView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var recentAndNearbyStations: [StationSearchItem]
    
    var body: some View {

        VStack(alignment: .leading) {
            Text("Nearby or Searched")
                .font(.title2)
                .padding(.bottom, 12)
            if (!recentAndNearbyStations.isEmpty) {
                VStack {
                    ForEach(recentAndNearbyStations.indices, id: \.self) { idx in
                        SearchItemView(station:
                                        recentAndNearbyStations[idx])
                        if(idx != recentAndNearbyStations.count - 1) {
                            Divider()
                        }
                    }
                }
                .padding(.leading, 4)
            } else {
                LoadingIndicator()
            }
        }
        .frame(width: .infinity)
        .padding()
        .background(Color(colorScheme == .light ? .systemBackground : .secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 8))
    }
}

