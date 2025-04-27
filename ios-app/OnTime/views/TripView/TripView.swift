//
//  TripView.swift
//  OnTime
//
//  Created by Robin Beer on 06.02.25.
//
import SwiftUI

struct TripView: View {
    let tripId: String
    let stationId: String
    let lineColor: String
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @StateObject private var viewModel = TripViewModel()
    @State private var expandedStopovers = false
    @State private var isMapExpanded = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.trip == nil {
                LoadingIndicator()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else if let trip = viewModel.trip {
                VStack(spacing: 16) {
                    // Header with origin and destination
                    TripHeaderView(trip: trip)

                    // Stopovers
                    VStack {
                        if !expandedStopovers {
                            if let selectedStopover = trip.stopovers.first(where: { $0.stop.id == stationId }) {
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
                    .padding()
                    .background(Color(colorScheme == .light ? .systemBackground : .secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    
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
                Button(action: {
                    print("test")
                }) {
                    Image(systemName: "star")
                        .font(.title2)
                }
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
