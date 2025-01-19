//
//  AllDeparturesElement.swift
//  Travel12
//
//  Created by Robin Beer on 12.07.24.
//

import SwiftUI
import SwiftData

struct AllDeparturesElement: View {
    
    let departuresForLine: [Departure]
    let line: Line
    let stationName: String
    let stationId: String
    
    var body: some View {
        let departuresByDirection = Dictionary(grouping: departuresForLine, by: { $0.direction })
        DisclosureGroup(line.name) {
                ForEach(Array(departuresByDirection.keys), id: \.self) { direction in
                    DirectionItem(direction: direction ?? "Other", departures: departuresByDirection[direction] ?? [], stationId: stationId, stationName: stationName, line: line)
                }
            }
            .listRowInsets(EdgeInsets())
    }
}

#Preview {
    AllDeparturesElement(departuresForLine: [], line: exampleLine, stationName: "Alexanderplatz", stationId: "123")
}
