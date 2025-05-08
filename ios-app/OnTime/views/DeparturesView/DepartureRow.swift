//
//  DepartureRow.swift
//  OnTime
//
//  Created by Robin Beer on 07.07.24.
//

import SwiftUI

struct DepartureRow: View {
    let departure: Departure
    let stationId: String
    
    var body: some View {
        NavigationLink(destination: TripView(tripId: departure.tripId, stationId: stationId, lineColor: departure.line.color?.bg ?? "#000")) {
            HStack {
                LineIndicator(line: departure.line)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text(departure.direction)
                        .font(.headline)
                }
                
                Spacer()
                
                VStack {
                    Text(departure.formattedWhen)
                        .font(.headline)
                        .foregroundStyle(departure.status == .delayed ? .red : .primary)
                    if(departure.status != .onTime) {
                        Text(departure.formattedPlannedWhen)
                            .font(.caption)
                            .strikethrough()
                    }
                    
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    DepartureRow(departure: Departure(tripId: "u5", when: "2025-05-05T12:34:00Z", plannedWhen: "2025-05-05T12:32:00Z", delay: -2, platform: "1", direction: "Hauptbahnhof", line: TransportLine(name: "U5", product: "subway", color: nil)), stationId: "qo0ghw0g")
}
