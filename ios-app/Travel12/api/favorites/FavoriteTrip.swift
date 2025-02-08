//
//  FavoriteTrip.swift
//  Travel12
//
//  Created by Robin Beer on 08.02.25.
//

import Foundation
import SwiftData

@Model
class FavoriteTrip {
    var lineId: String
    var destinationId: String
    var stationId: String
    var createdAt: Date
    var syncStatus: SyncStatus
    
    var key: String {
        "\(stationId)_\(lineId)_\(destinationId)"
    }
    
    init(lineId: String, stationId: String, destinationId: String, createdAt: Date = Date(), syncStatus: SyncStatus = .pending) {
        self.lineId = lineId
        self.destinationId = destinationId
        self.stationId = stationId
        self.createdAt = createdAt
        self.syncStatus = syncStatus
    }
}

enum SyncStatus: Int, Codable {
    case synced
    case pending
    case failed
}

enum FavoriteError: Error {
    case serverError(String)
    case persistenceError(String)
    case networkError(String)
}
