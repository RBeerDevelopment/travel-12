//
//  DeparturesViewFIilterSection.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 09.05.25.
//

import SwiftUI

struct DeparturesViewFilterSection: View {
    
    @Binding var selectedModes: Set<ProductType>
    @Binding var selectedLines: Set<TransportLine>
    var departures: [Departure]
    
    @State private var showFilters = false

    var body: some View {
        HStack {
            DepartureFilters(
                selectedModes: $selectedModes,
                selectedLines: $selectedLines,
                availableModes: extractTransportModes(departures: departures),
                availableLines: Array(extractLines(departures: departures, selectedModes: selectedModes))
            )
            
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    @Previewable @State var selectedModes = Set(demoDepartures.map { $0.line.product })
    @Previewable @State var selectedLines = Set(demoDepartures.map { $0.line })

    DeparturesViewFilterSection(
        selectedModes: $selectedModes,
        selectedLines: $selectedLines,
        departures: demoDepartures
    )
}

