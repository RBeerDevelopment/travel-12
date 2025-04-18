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
    
    // Add this function to filter departures
    func filteredDepartures(modes: Set<String>, lines: Set<String>) -> [Departure] {
        // If nothing is selected, show nothing
        if modes.isEmpty && lines.isEmpty {
            return []
        }
        
        // If all filters are selected or none are active, return all departures
        if (modes.count == extractTransportModes(departures: departures).count &&
            lines.count == extractLines(departures: departures).count) ||
           (modes.isEmpty && lines.isEmpty) {
            return departures
        }
        
        return departures.filter { departure in
            // If no modes are selected, don't filter by mode
            let modeMatch = modes.isEmpty || modes.contains(departure.line.product)
            
            // If no lines are selected, don't filter by line
            let lineMatch = lines.isEmpty || lines.contains(departure.line.name)
            
            return modeMatch && lineMatch
        }
    }
}
