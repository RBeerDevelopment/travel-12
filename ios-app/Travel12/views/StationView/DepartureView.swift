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
                    LoadingIndicator()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ForEach(viewModel.departures) { departure in
                        DepartureRow(departure: departure, stationId: stationId)
                    }
                }
            }
            .refreshable {
                await viewModel.fetchDepartures(stationId: stationId)
            }
            .overlay {
                if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.fetchDepartures(stationId: stationId)
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchDepartures(stationId: stationId)
            }
        }
        .frame(maxHeight: .infinity)
        .navigationTitle(stationName)
        
    }
}
