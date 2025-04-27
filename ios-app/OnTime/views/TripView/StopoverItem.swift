//
//  StopoverItem.swift
//  OnTime
//
//  Created by Robin Beer on 07.02.25.
//

import SwiftUI

struct StopoverItem: View {
    let stopover: Stopover
    let isSelectedStation: Bool
    var body: some View {
        VStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                NavigationLink(destination: DeparturesView(stationId: stopover.stop.id, stationName: stopover.stop.name)) {
                    Text(stopover.stop.name.replacingOccurrences(of: " (Berlin)", with: ""))
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .accentColor(.primary)
                
                if let arrival = stopover.arrival {
                    StopoverTimeRow(
                        title: "Arrival",
                        planned: stopover.plannedArrival ?? arrival,
                        actual: arrival,
                        delay: stopover.arrivalDelay,
                        platform: stopover.arrivalPlatform,
                        plannedPlatform: stopover.plannedArrivalPlatform
                    )
                    .frame(maxWidth: .infinity)
                }
                if let departure = stopover.departure {
                    StopoverTimeRow(
                        title: "Departure",
                        planned: stopover.plannedDeparture ?? departure,
                        actual: departure,
                        delay: stopover.departureDelay,
                        platform: stopover.departurePlatform,
                        plannedPlatform: stopover.plannedDeparturePlatform
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background {
            isSelectedStation ? Color.gray.opacity(0.2) : Color.clear
        }
        .cornerRadius(8)
    }
}

//#Preview {
//    StopoverItem()
//}
