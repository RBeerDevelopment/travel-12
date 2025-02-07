//
//  StationDepartureViewModel.swift
//  Travel12
//
//  Created by Robin Beer on 29.06.24.
//

import Combine
import SwiftUI

@MainActor
class DeparturesViewModel: ObservableObject {
    @Published var departures: [Departure] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchDepartures(stationId: String) async {
        isLoading = true
        error = nil
        
        do {
            let response = try await ApiClient.shared.fetchDepartures(stationId: stationId)
            departures = response?.departures ?? []
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
