//
//  Departures.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import Combine
import SwiftUI

struct DeparturesView: View {
    @StateObject private var viewModel = DeparturesViewModel()
    @State private var selectedModes = Set<String>()
    @State private var selectedLines = Set<String>()
    
    let stationId: String
    let stationName: String
    
    var filteredDepartures: [Departure] {
        return viewModel.filteredDepartures(
            modes: selectedModes,
            lines: selectedLines
        )
    }

    var body: some View {
        VStack() {
            DeparturesViewFilterSection(
                selectedModes: $selectedModes,
                selectedLines: $selectedLines,
                departures: viewModel.departures
            )
            
            if viewModel.isLoading && viewModel.departures.isEmpty {
                LoadingIndicator()
                    .frame(height: .infinity)
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
                        ForEach(filteredDepartures) { departure in
                            DepartureItem(departure: departure, stationId: stationId, stationName: stationName)
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
        .navigationTitle(stationName)
        
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
