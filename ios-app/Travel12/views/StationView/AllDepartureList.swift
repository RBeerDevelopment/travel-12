//
//  AllDepartureList.swift
//  Travel12
//
//  Created by Robin Beer on 30.06.24.
//

import SwiftUI
import SwiftData

struct AllDepartureList: View {
    
    let departures: [String: [Departure]]
    let stationId: String
    let stationName: String
    let lines: [Line]
    
    var body: some View {
        List{
            ForEach(departures.keys.sorted(), id: \.self) { lineName in
                AllDeparturesElement(departuresForLine: departures[lineName] ?? [], line: lines.first(where: { $0.name == lineName })!, stationName: stationName, stationId: stationId)
            }
        }.listStyle(.plain)
            .padding(.horizontal)
    }
}

#Preview {
    AllDepartureList(departures: ["U5": [exampleDeparture]], stationId: "test", stationName: "Alexanderplatz", lines: [exampleLine])
}
