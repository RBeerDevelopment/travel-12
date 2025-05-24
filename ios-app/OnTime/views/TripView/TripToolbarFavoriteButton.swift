//
//  TripToolbarFavoriteButton.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 30.04.25.
//

import SwiftUI
import SwiftData

struct TripToolbarFavoriteButton: View {
    let destinationId: String?
    let stationId: String?
    let lineId: String?
    let stationName: String?
    
    var isFavorite: Bool = false
    
    init(modelContext: ModelContext, destinationId: String?,
         stationId: String?,
         lineId: String?,
         stationName: String?
    ) {
       
        if let destinationId = destinationId, let stationId = stationId, let lineId = lineId, let stationName = stationName {
            
            self.destinationId = destinationId
            self.lineId = lineId
            self.stationId = stationId
            self.stationName = stationName
            
            let fetchDescriptor = FetchDescriptor<FavoriteTrip>()
            var fetchedTrips: [FavoriteTrip] = []
            do {
                fetchedTrips = try modelContext.fetch(fetchDescriptor)
            } catch {
                print("Error getting favorite trip", error)
            }
            
            self.isFavorite = fetchedTrips.contains(where: { $0.lineId == lineId && $0.stationId == stationId && $0.destinationId == destinationId
            })
        } else {
            self.destinationId = nil
            self.lineId = nil
            self.stationId = nil
            self.stationName = nil
        }
       
    }
    
    var body: some View {
        Button(action: {
            FavoritesManager.shared.toggleFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId, stationName: stationName)
        }) {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .tint(isFavorite ? .yellow : .gray)
        }
    }
}
