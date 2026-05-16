//
//  Array+DepartureFunctions.swift
//  OnTime
//
//  Created by Robin Beer on 26.02.25.
//

// Helper extension to get transport modes and lines from departures
func extractTransportModes(departures: [Departure]) -> [ProductType] {
    let modes = Set(departures.compactMap { departure in
        // Assuming each departure has a property like "mode" or "productName"
        // that indicates whether it's S-Bahn, U-Bahn, etc.
        departure.line.product
    })
    return Array(modes).sorted()
}

func extractLines(departures: [Departure], selectedModes: Set<ProductType>? = nil) -> Set<TransportLine> {
    let departuresToConsider = (selectedModes == nil || (selectedModes?.isEmpty ?? false)) ? departures : departures.filter { selectedModes!.contains($0.line.product) }

    return Set(departuresToConsider.compactMap{ $0.line }.sorted {
        $0.name < $1.name
    })
}
