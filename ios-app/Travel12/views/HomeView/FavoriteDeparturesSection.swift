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
                
                let departures = viewModel.departures
                
                ForEach(favorites) { favorite in
                    if departures[favorite.id]?.count ?? 0 > 0 {
                        FavoriteDepartureCard(
                            departures: departures[favorite.id] ?? [],
                            stationName: favorite.stationName,
                            stationId: favorite.stationId
                        )
                    } else {
                        FavoriteDepartureErrorCard(favorite: favorite, isRequestError: departures[favorite.id] == nil)
                    }
                    
                }
                Spacer()
            }
        }
        .background(Color(.systemGroupedBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            fetchAllDepartures()
        }
        .refreshable {
            fetchAllDepartures()
        }
        .onDisappear {
            viewModel.cancelFetch()
        }
    }
    
    private func fetchAllDepartures() {
        let requestData = favorites.map { FavoriteDepartureRequestData(stationId: $0.stationId, destination: $0.destinationId, id: $0.id) }
        
        
        viewModel.fetchFavoriteDepartures(requestData: requestData)
        
    }
}

