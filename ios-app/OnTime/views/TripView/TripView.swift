//
//  TripView.swift
//  OnTime
//
//  Created by Robin Beer on 06.02.25.
//

import SwiftUI
import SwiftData

struct TripView: View {
    let tripId: String
    let stationId: String
    let lineColor: String

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = TripViewModel()
    @State private var expandedStopovers = false
    @State private var isMapExpanded = false
    
    var selectedStopover: Stopover? {
        get {
            viewModel.trip?.stopovers.first(where: { $0.stop.id == stationId })
        }
    }

    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.trip == nil {
                LoadingIndicator()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else if let trip = viewModel.trip {
                VStack(spacing: 16) {
                    TripRemarksSection(remarks: trip.remarks)
                    // Header with origin and destination
                    TripHeaderView(trip: trip)

                    // Stopovers
                    VStack {
                        if !expandedStopovers {
                            if let selectedStopover = selectedStopover {
                                StopoverItem(stopover: selectedStopover, isSelectedStation: false)
                            }
                        } else {
                            StopoverListView(stopovers: trip.stopovers, selectedStationId: stationId)
                        }
                        Button(action: {
                            withAnimation {
                                expandedStopovers.toggle()
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text(expandedStopovers ? "Less Stops" : "More Stops")
                                    .font(.headline)
                                Image(systemName: expandedStopovers ? "chevron.up" : "chevron.down")
                                Spacer()
                            }
                        }
                    }
                    .modifier(TripCardModifier())
                    
                    if !expandedStopovers {
                        if let polylineFeatures = trip.polyline?.features {
                            TripMap(polylineFeatures: polylineFeatures, lineColor: lineColor)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("\(viewModel.trip?.line.name ?? "")")
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                TripToolbarFavoriteButton(modelContext: context, destinationId: viewModel.trip?.direction, stationId: stationId, lineId: viewModel.trip?.line.name, stationName: selectedStopover?.stop.name)
            }
        }
        .refreshable {
            await viewModel.fetchTrip(tripId: tripId)
        }
        .task {
            await viewModel.fetchTrip(tripId: tripId)
        }
    }
}
