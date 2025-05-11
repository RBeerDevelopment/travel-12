//
//  RecentSearchStation.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 10.05.25.
//

import Foundation
import SwiftData

struct StationSnapshot: Codable {
    let id: String
    let name: String
    let products: [String]
    let location: Location
}

let RECENT_SEARCH_LIMIT = 5

@Model
class RecentSearchStation: Identifiable {
    var id: String
    var stationSnapshot: StationSnapshot
    var lastSearched: Date
    
    init(from item: StationSearchItem, lastSearched: Date = Date()) {
            self.id = item.id
            self.stationSnapshot = StationSnapshot(
                id: item.id,
                name: item.name,
                products: item.products,
                location: item.location
            )
            self.lastSearched = lastSearched
        }
}
