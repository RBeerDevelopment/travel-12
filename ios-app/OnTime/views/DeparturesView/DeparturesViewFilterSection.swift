//
//  DeparturesViewFIilterSection.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 09.05.25.
//

import SwiftUI

struct DeparturesViewFilterSection: View {
    
    @Binding var selectedModes: Set<String>
    @Binding var selectedLines: Set<String>
    var departures: [Departure]
    
    @State private var showFilters = false

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation(.easeIn(duration: 0.25)) {
                    showFilters.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Filters")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
            .padding(.trailing)
        }
        .padding(.trailing, 4)
        
        if showFilters {
            HStack {
                DepartureFilters(
                    selectedModes: $selectedModes,
                    selectedLines: $selectedLines,
                    availableModes: extractTransportModes(departures: departures),
                    availableLines: extractLines(departures: departures, selectedModes: selectedModes)
                )
                
            }
            .transition(.scale)
            .padding(.horizontal, 4)
        }
    }
}

