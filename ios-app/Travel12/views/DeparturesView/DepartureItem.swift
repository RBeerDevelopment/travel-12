//
//  DepartureItem.swift
//  Travel12
//
//  Created by Robin Beer on 08.02.25.
//

import SwiftUI
import SwiftData

struct DepartureItem: View {
    @Query var favoriteTrips: [FavoriteTrip]
    let departure: Departure
    let stationId: String
    let stationName: String
    
    var body: some View {
        let lineId = departure.line.name
        let destinationId = departure.direction
        let isFavorite = favoriteTrips.first(where: { $0.lineId == lineId && $0.stationId == stationId && $0.destinationId == destinationId
        }) != nil
        
        DepartureRow(departure: departure, stationId: stationId)
            .favoriteActionSheet(lineId: lineId, stationId: stationId, destinationId: destinationId, stationName: stationName, isFavorite: isFavorite)
    }
}
