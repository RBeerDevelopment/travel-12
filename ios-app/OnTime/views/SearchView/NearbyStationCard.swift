//
//  NearbyStationCard.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 06.04.26.
//

import SwiftUI

struct NearbyStationCard: View {
    
    let station: StationSearchItem
    
    var body: some View {
        NavigationLink {
            DeparturesView(stationId: station.id.components(separatedBy: ":")[2], stationName: station.name)
        } label: {
            HStack {
                VStack {
                    Image(systemName: getProductIconName(getMostImportantProductType(from: station.lines) ?? .bus))
                        .frame(width: 32, height: 32)
                        .padding(8)
                        .background(Color(.systemGroupedBackground))
                        .clipShape(Circle())
                    Spacer()
                }
                VStack(alignment: .leading) {
                    Text(station.cleanedName)
                        .font(.title2)
                        .bold()
                    Text(station.distanceToUser != nil ? "\(formatDistance(station.distanceToUser!)!) away" : "")
                        .font(.footnote)
                    SearchItemLineGrid(lines: station.lines)
                }
                .padding(.leading, 8)
            }
        }
    }
}

#Preview {
    var stations = [
        demoStations[0]
    ]
    let newStation = StationSearchItem(id: "222", name: "Frankfurter Allee", lines: [], location: Location(id: "123", latitude: 52.475465, longitude: 13.365575))
    newStation.distanceToUser = 100
    newStation.lines = demoStations[0].lines
    
    stations.append(newStation)
    
    return List {
        Section {
            NearbyStationCard(station: stations[0])
        }
        Section {
            NearbyStationCard(station: stations[1])
        }
    }
    .listStyle(.insetGrouped)
    .listSectionSpacing(12)
}
