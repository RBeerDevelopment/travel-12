//
//  StationDepartureViewModel.swift
//  OnTime
//
//  Created by Robin Beer on 29.06.24.
//

import Combine
import SwiftUI


let DEFAULT_FETCH_DURATION = 60

// when earlier or later departures are requested,
// we do that in 20 min intervals
let ADDITIONAL_FETCH_INTERVAL = 20

@MainActor
class DeparturesViewModel: ObservableObject {
    @Published var departures: [Departure] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    var earliestDepartureTimestamp: Date? {
        return departures.first?.whenDate
    }
    
    var currentDuration: Int = DEFAULT_FETCH_DURATION
    
    func fetchDepartures(stationId: String, startTime: Date = Date(), duration: Int = DEFAULT_FETCH_DURATION) async {
        isLoading = true
        error = nil
        
        do {
            let response = try await ApiClient.shared.fetchDepartures(stationId: stationId, startTime: startTime, duration: duration)
            departures = response?.departures ?? []
        } catch {
            self.error = error
        }
        
        currentDuration = duration
        
        isLoading = false
    }
    
    func fetchEarlierDepartures(_ stationId: String) async {
        let startTime: Date = earliestDepartureTimestamp ?? Date()
        
        let newStartTime = Calendar.current.date(byAdding: .minute, value: -ADDITIONAL_FETCH_INTERVAL, to: startTime)!
        let newDuration = currentDuration + ADDITIONAL_FETCH_INTERVAL
        
        await fetchDepartures(stationId: stationId, startTime: newStartTime, duration: newDuration)
    }
    
    func fetchLaterDepartures(_ stationId: String) async {
        let newDuration = currentDuration + ADDITIONAL_FETCH_INTERVAL
        let startTime = earliestDepartureTimestamp ?? Date()
        
        await fetchDepartures(stationId: stationId, startTime: startTime, duration: newDuration)
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
