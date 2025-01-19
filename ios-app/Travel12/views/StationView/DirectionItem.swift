//
//  DepartureItem.swift
//  Travel12
//
//  Created by Robin Beer on 30.06.24.
//

import Combine
import SwiftData
import SwiftUI

struct DirectionItem: View {
    
    let direction: String
    let departures: [Departure]
    let stationId: String
    let stationName: String
    let line: Line
    
    var body: some View {
        VStack(alignment: .leading) {
            if(departures.count > 0) {
                HStack {
                    Text(departures[0].direction ?? "").font(.title3)
                }
            }
            
            ForEach(departures) { departure in
                if let departureTime = departure.when {
                    DepartureTimeRow(departureTime: departureTime, delay: departure.delay ?? 0)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DirectionItem(direction: "Warschauer Straße", departures: [exampleDeparture], stationId: "Test", stationName: "Alexanderplatz", line: exampleLine)
}
