//
//  FavoriteTripErrorCard.swift
//  OnTime
//
//  Created by Robin Beer on 22.02.25.
//

import SwiftUI

struct FavoriteDepartureErrorCard: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var favorite: FavoriteTrip
    var isRequestError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    VStack(alignment: .leading) {
                        Text(favorite.stationName)
                                .font(.headline)
                                .lineLimit(1)
                        
                    }
                    
                }
            Text(isRequestError ? "Error loading departures" : "No departures found within the next hour")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
        }
        .padding()
        .background(Color(colorScheme == .light ? .systemBackground : .secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 8))
    }
}
