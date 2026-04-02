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
            
            self.isFavorite = FavoritesManager.shared.isFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId)
            
        } else {
            self.destinationId = nil
            self.lineId = nil
            self.stationId = nil
            self.stationName = nil
        }
    }
    
    var body: some View {
        Button(action: {
            _ = FavoritesManager.shared.toggleFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId, stationName: stationName)
        }) {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .tint(isFavorite ? .yellow : .gray)
        }
    }
}
