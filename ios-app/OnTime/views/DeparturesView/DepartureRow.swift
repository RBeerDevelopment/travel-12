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
                
                VStack(alignment: .trailing) {
                    Text(departure.formattedWhen)
                        .font(.headline)
                    if let delay = departure.delay {
                        if delay > 0 {
                            Text("+\(delay / 60) min")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

