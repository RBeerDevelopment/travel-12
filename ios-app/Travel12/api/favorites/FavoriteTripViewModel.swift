//
//  FavoriteTripViewModel.swift
//  Travel12
//
//  Created by Robin Beer on 13.02.25.
//

import Combine
import SwiftUI

struct FavoriteDepartureRequestData {
    var stationId: String
    var destination: String
    var id: String
}

@MainActor
class FavoriteTripViewModel: ObservableObject {
    @Published var departures: [String: [Departure]] = [:]
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchFavoriteDepartures(requestData: [FavoriteDepartureRequestData]) async {
        isLoading = true
        error = nil
        
        do {
            let response = try await ApiClient.shared.fetchMultipleDepartures(requestData: requestData)
            departures = response
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
