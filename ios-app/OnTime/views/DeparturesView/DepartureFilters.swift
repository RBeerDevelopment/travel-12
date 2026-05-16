//
//  DepartureFilter.swift
//  OnTime
//
//  Created by Robin Beer on 26.02.25.
//

import SwiftUI

struct DepartureFilters: View {
    @Binding var selectedModes: Set<ProductType>
    @Binding var selectedLines: Set<TransportLine>
    
    let availableModes: [ProductType]
    let availableLines: [TransportLine]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(title: "All Modes", isSelected: false, action: {
                            selectedModes = Set(availableModes)
                        }, longPressAction: {})
                        ForEach(availableModes, id: \.self) { mode in
                            FilterChip(
                                title: mode.rawValue,
                                isSelected: selectedModes.contains(mode),
                                action: {
                                    toggleSelection(for: mode, in: $selectedModes)
                                },
                                longPressAction: {
                                    selectOnly(for: mode, in: $selectedModes)
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
                                title: line.name,
                                isSelected: selectedLines.contains(line),
                                action: {
                                    toggleSelection(for: line, in: $selectedLines)
                                },
                                longPressAction: {
                                    selectOnly(for: line, in: $selectedLines)
                                },
                                backgroundColor: Color(hex: line.color!.bg).pastel
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
                    Text("All")
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
    
    private func toggleSelection<T>(for item: T, in selection: Binding<Set<T>>) {
        if selection.wrappedValue.contains(item) {
            selection.wrappedValue.remove(item)
        } else {
            selection.wrappedValue.insert(item)
        }
    }
    
    private func selectOnly<T>(for item: T, in selection: Binding<Set<T>>) {
        selection.wrappedValue = [item]
    }
}




// Preview provider for SwiftUI Canvas
struct DepartureFilters_Previews: PreviewProvider {
    static var previews: some View {
        DepartureFilters(
            selectedModes: .constant([.subway, .suburban]),
            selectedLines: .constant(Set(demoDepartures.map { $0.line })),
            availableModes: [.subway, .suburban, .tram, .bus],
            availableLines: demoDepartures.map { $0.line }
        )
        .previewLayout(.sizeThatFits)
    }
}
