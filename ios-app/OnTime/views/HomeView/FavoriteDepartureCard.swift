//
//  FavoriteDepartureCard.swift
//  OnTime
//
//  Created by Robin Beer on 13.02.25.
//

import SwiftUI

struct FavoriteDepartureCard: View {
    let departures: [Departure]
    let stationName: String
    let stationId: String
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let firstDeparture = departures.first {
                HStack(spacing: 8) {
                    LineIndicator(line: firstDeparture.line)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        NavigationLink(destination: DeparturesView(stationId: stationId, stationName: stationName)) {
                            Text(stationName)
                                .font(.headline)
                                .lineLimit(1)
                        }
                        .accentColor(.primary)
                        if(firstDeparture.line.name != "S41" && firstDeparture.line.name != "S42") {
                            Text("To: \(firstDeparture.direction)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(departures.prefix(4), id: \.id) { departure in
                    HStack {
                        Text(departure.formattedWhen)
                            .font(.headline)
                            .foregroundStyle(departure.status == .delayed ? .red : .primary)
                        if(departure.status != .onTime) {
                            Text(departure.formattedPlannedWhen)
                                .font(.subheadline)
                                .strikethrough()
                        }
                        
                        Spacer()
                        
                        if let platform = departure.platform {
                            Text("Platform \(platform)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(.leading, 4)
        }

        
    }
}
