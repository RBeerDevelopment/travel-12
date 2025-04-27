//
//  FavoriteManager.swift
//  OnTime
//
//  Created by Robin Beer on 08.02.25.
//

import SwiftUI
import SwiftData

@Observable
class FavoritesManager {
    static let shared = FavoritesManager()
    private var modelContext: ModelContext
    let apiClient = ApiClient.shared
    
    private init() {
        let container = try! ModelContainer(for: FavoriteTrip.self)
        modelContext = ModelContext(container)
    }
    
    func isFavorite(lineId: String, stationId: String, destinationId: String) -> Bool {
        let descriptor = FetchDescriptor<FavoriteTrip>(
            predicate: #Predicate<FavoriteTrip> { favorite in
                favorite.lineId == lineId && favorite.stationId == stationId && favorite.destinationId == destinationId
            }
        )
        print(try? modelContext.fetch(descriptor))
        let favoriteDescriptorCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        print(descriptor)
        print(favoriteDescriptorCount)
        return favoriteDescriptorCount > 0
    }
    
    func toggleFavorite(lineId: String, stationId: String, destinationId: String, stationName: String) {
        if isFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId) {
            removeFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId)
        } else {
            addFavorite(lineId: lineId, stationId: stationId, stationName: stationName, destinationId: destinationId)
        }
    }
    
    private func addFavorite(lineId: String, stationId: String, stationName: String, destinationId: String) {
        let favorite = FavoriteTrip(lineId: lineId, stationId: stationId, destinationId: destinationId, stationName: stationName)
        modelContext.insert(favorite)
        try? modelContext.save()
        
        Task {
            try? await uploadToServer(favorite)
        }
    }
    
    private func removeFavorite(lineId: String, stationId: String, destinationId: String) {
        let descriptor = FetchDescriptor<FavoriteTrip>(
            predicate: #Predicate<FavoriteTrip> { favorite in
                favorite.lineId == lineId && favorite.stationId == stationId && favorite.destinationId == destinationId
            }
        )
        
        guard let favorite = try? modelContext.fetch(descriptor).first else { return }
        
        modelContext.delete(favorite)
        try? modelContext.save()
        
        Task {
            try? await deleteFromServer(favorite.id)
        }
    }
    
    private func uploadToServer(_ favorite: FavoriteTrip) async throws {
        try await apiClient.uploadFavoriteTrip(trip: favorite)
    }
    
    private func deleteFromServer(_ id: String) async throws {
        try await apiClient.deleteFavoriteTrip(id)
    }
}
