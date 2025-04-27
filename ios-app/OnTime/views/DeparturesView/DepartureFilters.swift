//
//  DepartureFilter.swift
//  OnTime
//
//  Created by Robin Beer on 26.02.25.
//

import SwiftUI

struct DepartureFilters: View {
    @Binding var selectedModes: Set<String>
    @Binding var selectedLines: Set<String>
    
    let availableModes: [String]
    let availableLines: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Mode")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(availableModes, id: \.self) { mode in
                            FilterChip(
                                title: mode,
                                isSelected: selectedModes.contains(mode),
                                action: {
                                    toggleSelection(for: mode, in: $selectedModes)
                                }
                            )
                        }
                    }
                }
                .padding([.horizontal, .bottom])
                
                Text("Lines")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(availableLines, id: \.self) { line in
                            FilterChip(
                                title: line,
                                isSelected: selectedLines.contains(line),
                                action: {
                                    toggleSelection(for: line, in: $selectedLines)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
            }
            
            HStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                    selectedModes = Set(availableModes)
                    selectedLines = Set(availableLines)
                }) {
                    Text("Select All")
                        .font(.subheadline)
                }
                
                Button(action: {
                    selectedModes.removeAll()
                    selectedLines.removeAll()
                }) {
                    Text("Clear")
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private func toggleSelection(for item: String, in selection: Binding<Set<String>>) {
        if selection.wrappedValue.contains(item) {
            selection.wrappedValue.remove(item)
        } else {
            selection.wrappedValue.insert(item)
        }
    }
}




// Preview provider for SwiftUI Canvas
struct DepartureFilters_Previews: PreviewProvider {
    static var previews: some View {
        DepartureFilters(
            selectedModes: .constant(["S-Bahn", "U-Bahn"]),
            selectedLines: .constant(["U5", "S1"]),
            availableModes: ["S-Bahn", "U-Bahn", "Tram", "Bus"],
            availableLines: ["U1", "U2", "U5", "S1", "S5", "S7", "RE6", "S42", "S41"]
        )
        .previewLayout(.sizeThatFits)
    }
}
