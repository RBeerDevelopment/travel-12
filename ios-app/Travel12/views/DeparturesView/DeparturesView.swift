//
//  Departures.swift
//  Travel12
//
//  Created by Robin Beer on 28.06.24.
//

import Combine
import SwiftUI

struct DeparturesView: View {
    @StateObject private var viewModel = DeparturesViewModel()
    @State private var selectedModes = Set<String>()
    @State private var selectedLines = Set<String>()
    @State private var showFilters = false
    
    let stationId: String
    let stationName: String

    var body: some View {
        VStack {
            // Filter toggle button
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeIn(duration: 0.25)) {
                        showFilters.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filters")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding(.trailing)
            }.padding(.trailing, 4)
            if showFilters {
                HStack {
                    DepartureFilters(
                        selectedModes: $selectedModes,
                        selectedLines: $selectedLines,
                        availableModes: extractTransportModes(departures: viewModel.departures),
                        availableLines: extractLines(departures: viewModel.departures, selectedModes: selectedModes)
                    )
                    
                }
                .transition(.scale)
                .padding(.horizontal, 4)
            }
            List {
                if viewModel.isLoading && viewModel.departures.isEmpty {
                    LargeLoadingIndicator()
                } else {
                    Button("Show Ealier") {
                        Task {
                            await viewModel.fetchEarlierDepartures(stationId: stationId)
                        }
                    }
                    .disabled(viewModel.isLoading)
                    ForEach(viewModel.filteredDepartures(
                        modes: selectedModes,
                        lines: selectedLines
                    )) { departure in
                        DepartureRow(departure: departure, stationId: stationId)
                    }
                    Button("Show Later") {
                        Task {
                            await viewModel.fetchLaterDepartures(stationId: stationId)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .contentMargins(.top, 4)
            .refreshable {
                Task {
                    await loadDepartures()
                }
            }
            .overlay {
                if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await loadDepartures()
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchDepartures(stationId: stationId)
                
                // Initialize filters with all available options selected
                if selectedModes.isEmpty {
                    selectedModes = Set(extractTransportModes(departures: viewModel.departures))
                }
                if selectedLines.isEmpty {
                    selectedLines = Set(extractLines(departures: viewModel.departures))
                }
            }
        }
        .frame(maxHeight: .infinity)
        .navigationTitle(stationName)
        
    }
    
     func loadDepartures() async {
        await viewModel.fetchDepartures(stationId: stationId)
    }
}
