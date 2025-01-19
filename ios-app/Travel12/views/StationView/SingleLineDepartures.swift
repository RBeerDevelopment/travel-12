//
//  SingleLineDepartures.swift
//  Travel12
//
//  Created by Robin Beer on 07.07.24.
//

import SwiftUI
import SwiftData

struct SingleLineDepartures: View {
    
    let departures: [Departure]
    let line: Line
    let stationId: String
    let stationName: String
    
    var departuresByDirection: [String: [Departure]] {
        Dictionary(grouping: departures, by: { $0.direction ?? "Other" })
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(line.name).font(.headline).padding(.horizontal)
            List(departuresByDirection.keys.sorted(), id: \.self) { direction in
                DirectionItem(direction: direction, departures: departuresByDirection[direction] ?? [], stationId: stationId,
                              stationName: stationName, line: line)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    SingleLineDepartures(departures: [exampleDeparture], line: exampleLine, stationId: "test", stationName: "Alexanderplatz")
}
