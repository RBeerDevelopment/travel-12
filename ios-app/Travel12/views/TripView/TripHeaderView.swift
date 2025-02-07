//
//  TripHeaderView.swift
//  Travel12
//
//  Created by Robin Beer on 06.02.25.
//

import SwiftUI

struct TripHeaderView: View {
    let trip: Trip
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("From")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(minWidth: 40, alignment: .leading)
                Text(trip.origin.name)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack(spacing: 8) {
                Text("To")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(minWidth: 40, alignment: .leading)
                Text(trip.destination.name)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(colorScheme == .light ? .systemBackground : .secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}
