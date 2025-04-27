//
//  FavoriteTrip.swift
//  OnTime
//
//  Created by Robin Beer on 08.02.25.
//

import Foundation
import SwiftData

@Model
class FavoriteTrip: Identifiable {
    var id: String
    var lineId: String
    var destinationId: String
    var stationName: String
    var stationId: String
    var createdAt: Date
    var syncStatus: SyncStatus
    
    init(lineId: String, stationId: String, destinationId: String, stationName: String, createdAt: Date = Date(), syncStatus: SyncStatus = .pending) {
        self.id = generateNanoId()
        self.lineId = lineId
        self.destinationId = destinationId
        self.stationId = stationId
        self.stationName = stationName
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
