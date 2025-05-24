//
//  FavoriteDeparturesSection.swift
//  OnTime
//
//  Created by Robin Beer on 13.02.25.
//

import SwiftUI
import SwiftData

struct FavoriteDeparturesView: View {
    
    @Query private var favorites: [FavoriteTrip]
    @StateObject private var viewModel = FavoriteTripViewModel()
    @Environment(\.presentToast) var presentToast
    
    var body: some View {
        List {
            if viewModel.isLoading && viewModel.departures.isEmpty {
                LoadingIndicator()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                let departures = viewModel.departures
                
                ForEach(favorites) { favorite in
                    if departures[favorite.id]?.count ?? 0 > 0 {
                        FavoriteDepartureCard(
                            departures: departures[favorite.id] ?? [],
                            stationName: favorite.stationName,
                            stationId: favorite.stationId
                        )
                        .favoriteActionSheet(lineId: favorite.lineId, stationId: favorite.stationId, destinationId: favorite.destinationId, stationName: favorite.stationName, isFavorite: true, showToast: { success in
                                showFavoriteToast(presentToast: presentToast, isRemove: true, isSuccess: success)
                        })
                    } else {
                        FavoriteDepartureErrorCard(favorite: favorite, isRequestError: departures[favorite.id] == nil)
                            .favoriteActionSheet(lineId: favorite.lineId, stationId: favorite.stationId, destinationId: favorite.destinationId, stationName: favorite.stationName, isFavorite: true, showToast: { success in
                                showFavoriteToast(presentToast: presentToast, isRemove: true, isSuccess: success)
                        })
                    }
                    
                }
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

