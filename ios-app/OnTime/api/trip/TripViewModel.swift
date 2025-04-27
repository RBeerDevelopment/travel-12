//
//  TripViewModel.swift
//  OnTime
//
//  Created by Robin Beer on 06.02.25.
//


import Combine
import SwiftUI

@MainActor
class TripViewModel: ObservableObject {
    @Published var trip: Trip? = nil
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchTrip(tripId: String) async {
        isLoading = true
        error = nil
        
        do {
            let response = try await ApiClient.shared.fetchTrip(tripId: tripId)
            trip = response?.trip
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
