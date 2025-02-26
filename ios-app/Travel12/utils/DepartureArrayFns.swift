//
//  Array+DepartureFunctions.swift
//  Travel12
//
//  Created by Robin Beer on 26.02.25.
//

// Helper extension to get transport modes and lines from departures
func extractTransportModes(departures: [Departure]) -> [String] {
    let modes = Set(departures.compactMap { departure in
        // Assuming each departure has a property like "mode" or "productName"
        // that indicates whether it's S-Bahn, U-Bahn, etc.
        departure.line.product // or whatever property contains the mode
    })
    return Array(modes).sorted()
}

func extractLines(departures: [Departure], selectedModes: Set<String>? = nil) -> [String] {
    
    let departuresToConsider = selectedModes == nil ? departures : departures.filter { selectedModes!.contains($0.line.product) }
    let lines = Set(departuresToConsider.compactMap { departure in
        departure.line.name // or whatever property contains the line name
    })
    return Array(lines).sorted()
}
