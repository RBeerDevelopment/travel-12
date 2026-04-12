//
//  InactiveStationSearchView.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 06.04.26.
//

import SwiftUI
import SwiftData

struct InactiveStationSearchView: View {
    
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var stationViewModel: StationViewModel
    
    var sortedNearbyStations: [StationSearchItem] {
        let deduplicatedStations = Set(stationViewModel.nearbyStation).sorted(by: {
            ($0.distanceToUser ?? .infinity) < ($1.distanceToUser ?? .infinity)
        })
        return deduplicatedStations
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Nearby Stations")
                .font(.title2)
                .bold()
                .padding(.leading, 16)
            List {
                ForEach(sortedNearbyStations) { station in
                    Section {
                        NearbyStationCard(station: station)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .listSectionSpacing(12)
            .contentMargins(.top, 0)
        }
        .background(Color(.systemGroupedBackground))
    }
}
#Preview {
    let container = try! ModelContainer(for: FavoriteTrip.self, RecentSearchStation.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let viewModel = StationViewModel(locationManager: LocationManager(), context: container.mainContext)
    viewModel.nearbyStation = [
        StationSearchItem(
            id: "900000100003",
            name: "S+U Alexanderplatz",
            lines: [
                StationSearchItemLine(name: "U2", color: "#FF3300", product: .subway),
                StationSearchItemLine(name: "U5", color: "#7E5330", product: .subway),
                StationSearchItemLine(name: "S5", color: "#FF7A00", product: .suburban),
            ],
            location: Location(id: "900000100003", latitude: 52.521508, longitude: 13.411267)
        ),
        StationSearchItem(
            id: "900000100001",
            name: "S+U Friedrichstraße",
            lines: [
                StationSearchItemLine(name: "S1", color: "#DE4DA4", product: .suburban),
                StationSearchItemLine(name: "U6", color: "#8C6DAB", product: .subway),
            ],
            location: Location(id: "900000100001", latitude: 52.520268, longitude: 13.387145)
        ),
        StationSearchItem(
            id: "900000023201",
            name: "U Kottbusser Tor",
            lines: [
                StationSearchItemLine(name: "U1", color: "#7DAD4C", product: .subway),
                StationSearchItemLine(name: "U8", color: "#1A5DAB", product: .subway),
                StationSearchItemLine(name: "M29", color: "#00A0DE", product: .bus),
            ],
            location: Location(id: "900000023201", latitude: 52.499044, longitude: 13.418347)
        ),
    ]

    return InactiveStationSearchView()
        .environmentObject(viewModel)
        .modelContainer(container)
}

