//
//  StationView.swift
//  Travel12
//
//  Created by Robin Beer on 28.06.24.
//

import Combine
import SwiftUI

struct DeparturesView: View {
    @StateObject private var viewModel = DeparturesViewModel()
    let stationId: String
    let stationName: String

    var body: some View {
        VStack {
            List {
                if viewModel.isLoading && viewModel.departures.isEmpty {
                    LargeLoadingIndicator()
                } else {
                    ForEach(viewModel.departures) { departure in
                        DepartureItem(departure: departure, stationId: stationId, stationName: stationName)
                    }
                }
            }
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
                await loadDepartures()
            }
        }
        .frame(maxHeight: .infinity)
        .navigationTitle(stationName)
        
    }
    
     func loadDepartures() async {
        await viewModel.fetchDepartures(stationId: stationId)
    }
}
