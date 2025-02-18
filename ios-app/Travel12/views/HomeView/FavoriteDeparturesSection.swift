//
//  FavoriteDeparturesSection.swift
//  Travel12
//
//  Created by Robin Beer on 13.02.25.
//

import SwiftUI
import SwiftData

struct FavoriteDeparturesView: View {
    @Query private var favorites: [FavoriteTrip]
    
    @StateObject private var viewModel = FavoriteTripViewModel()
    
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading && viewModel.departures.isEmpty {
                LoadingIndicator()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .onAppear {
                        print(favorites)
                    }
            } else {
                ForEach(favorites) { favorite in
                    FavoriteDepartureCard(
                        departures: viewModel.departures[favorite.id] ?? [],
                        stationName: favorite.stationName,
                        stationId: favorite.stationId
                    )
                }
                Spacer()
            }
        }
        .background(Color(.systemGroupedBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await fetchAllDepartures()
        }
        .refreshable {
            await fetchAllDepartures()
        }
    }
    
    private func fetchAllDepartures() async {
        let requestData = favorites.map { FavoriteDepartureRequestData(stationId: $0.stationId, destination: $0.destinationId, id: $0.id) }
        
        await viewModel.fetchFavoriteDepartures(requestData: requestData)
        
    }
}

