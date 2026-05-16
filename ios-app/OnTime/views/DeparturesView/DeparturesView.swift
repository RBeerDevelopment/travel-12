//
//  Departures.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import Combine
import SwiftUI

struct DeparturesView: View {
    @StateObject private var viewModel: DeparturesViewModel
    @State private var selectedModes = Set<ProductType>()
    @State private var selectedLines = Set<TransportLine>()
    
    let stationId: String
    let stationName: String
    let cleanedStationName: String
    
    init(stationId: String, stationName: String, cleanedStationName: String, viewModel: DeparturesViewModel = .init()) {
        self.stationId = stationId
        self.stationName = stationName
        self.cleanedStationName = cleanedStationName
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var filteredDepartures: [Departure] {
        return viewModel.filteredDepartures(
            modes: selectedModes,
            lines: Set(selectedLines.map { $0.name })
        )
    }

    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("LIVE DATA")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.red)
                Text(stationName)
                    .font(.largeTitle)
                    .bold()
            }
            .padding(.leading, 8)
            
            DeparturesViewFilterSection(
                selectedModes: $selectedModes,
                selectedLines: $selectedLines,
                departures: viewModel.departures
            )
            
            if viewModel.isLoading && viewModel.departures.isEmpty {
                Spacer()
                LoadingIndicator()
                Spacer()
            } else {
                List {
                    if viewModel.error == nil {
                        Button("Show Ealier") {
                            fetchEarlier()
                        }
                        .disabled(viewModel.isLoading)
                    }
                    if viewModel.error != nil {
                        Text("There was an error loading the data. Please try again later.")
                    } else if (filteredDepartures.isEmpty) {
                        Text("No departures for your selected filters.")
                    } else if viewModel.departures.isEmpty {
                        Text("No departures for this station.")
                    } else {
                        ForEach(filteredDepartures.enumerated(), id: \.element) { idx, departure in
                            DepartureItem(departure: departure, stationId: stationId, stationName: stationName, index: idx)
                        }
                    }
                    if viewModel.error == nil {
                        Button("Show Later") {
                            fetchLater()
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
                .contentMargins(.top, 16)
                .refreshable {
                    loadDepartures()
                }
                .overlay {
                    if let error = viewModel.error {
                        ErrorView(error: error) {
                            loadDepartures()
                        }
                    }
                }
                .task {
                    await initView()
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Station")
        
    }
    
    func fetchEarlier() {
        Task {
            await viewModel.fetchEarlierDepartures(stationId)
        }
    }
    
    func fetchLater() {
        Task {
            await viewModel.fetchLaterDepartures(stationId)
        }
    }
    
    func loadDepartures() {
        Task {
            await viewModel.fetchDepartures(stationId: stationId)
        }
    }
    
    func initView() async {
        loadDepartures()
        
        // Initialize filters with all available options selected
        if selectedModes.isEmpty {
            selectedModes = Set(extractTransportModes(departures: viewModel.departures))
        }
        if selectedLines.isEmpty {
            selectedLines = Set(extractLines(departures: viewModel.departures))
        }
    }
}
#Preview {
    NavigationStack {
        DeparturesView(
            stationId: "900000100003",
            stationName: "Berlin Alexanderplatz",
            cleanedStationName: "Berlin Alexanderplatz",
            viewModel: DeparturesViewModel(previewDepartures: demoDepartures)
        )
    }
}

