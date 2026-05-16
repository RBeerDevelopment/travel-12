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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let firstDeparture = departures.first {
                NavigationLink(destination: DeparturesView(stationId: stationId, stationName: stationName, cleanedStationName: stationName)) {
                    HStack(spacing: 16) {
                        LineIndicator(line: firstDeparture.line)
                            .frame(width: 48, height: 48)
                        VStack(alignment: .leading) {
                            
                            Text(stationName)
                                .font(.headline)
                                .lineLimit(1)
                            
                            if(firstDeparture.line.name != "S41" && firstDeparture.line.name != "S42") {
                                Text("→ \(firstDeparture.direction)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        .accentColor(.primary)
                    }
                }
            }
    
            TimelineView(.everyMinute) { context in
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 12) {
                        ForEach(departures.prefix(5), id: \.id) { departure in
                            let minutes = Int(departure.whenDate.timeIntervalSince(context.date) / 60)
                            
                            VStack {
                                Text(minutes == 0 ? "now" : "\(minutes)m")
                                    .font(.headline)
                                    .bold()
                                    .foregroundStyle(departure.status == .delayed ? .red : .primary)
                                Text(departure.whenDate.formatted(date: .omitted, time: .shortened))
                                    .font(.caption)
                            }
                            .frame(width: 60, height: 60)
                            .padding(4)
                            .background(Color(.systemGroupedBackground).clipShape(RoundedRectangle(cornerRadius: 16)))
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(6)
    }
}

#Preview {
    NavigationStack {
        List {
            FavoriteDepartureCard(
                departures: demoDepartures,
                stationName: "Alexanderplatz",
                stationId: "900000100003"
            )
        }
    }
}
