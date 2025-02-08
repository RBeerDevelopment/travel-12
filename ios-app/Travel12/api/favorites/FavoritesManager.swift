//
//  FavoriteManager.swift
//  Travel12
//
//  Created by Robin Beer on 08.02.25.
//

import SwiftUI
import SwiftData

@Observable
class FavoritesManager {
    static let shared = FavoritesManager()
    private var modelContext: ModelContext
    
    private init() {
        let container = try! ModelContainer(for: FavoriteTrip.self)
        modelContext = ModelContext(container)
    }
    
    func isFavorite(lineId: String, stationId: String, destinationId: String) -> Bool {
        let descriptor = FetchDescriptor<FavoriteTrip>(
            predicate: #Predicate<FavoriteTrip> { favorite in
                true
//                favorite.lineId == lineId && favorite.stationId == stationId
//                    && favorite.destinationId == destinationId
            }
        )
        print(try? modelContext.fetch(descriptor))
        let favoriteDescriptorCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        print(descriptor)
        print(favoriteDescriptorCount)
        return favoriteDescriptorCount > 0
    }
    
    func toggleFavorite(lineId: String, stationId: String, destinationId: String) {
        print("toggleFavorite", lineId, stationId, destinationId)
        if isFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId) {
            removeFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId)
        } else {
            addFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId)
        }
    }
    
    private func addFavorite(lineId: String, stationId: String, destinationId: String) {
        let favorite = FavoriteTrip(lineId: lineId, stationId: stationId, destinationId: destinationId)
        modelContext.insert(favorite)
        try? modelContext.save()
        
        Task {
            try? await uploadToServer(favorite)
        }
    }
    
    private func removeFavorite(lineId: String, stationId: String, destinationId: String) {
        let descriptor = FetchDescriptor<FavoriteTrip>(
            predicate: #Predicate<FavoriteTrip> { favorite in
                favorite.lineId == lineId && favorite.stationId == stationId
                && favorite.destinationId == destinationId
            }
        )
        
        guard let favorite = try? modelContext.fetch(descriptor).first else { return }
        
        modelContext.delete(favorite)
        try? modelContext.save()
        
        // Placeholder for API call
        Task {
            try? await deleteFromServer(favorite)
        }
    }
    
    // MARK: - Server communication (to be implemented)
    
    private func uploadToServer(_ favorite: FavoriteTrip) async throws {
        // TODO: Implement your API call here
    }
    
    private func deleteFromServer(_ favorite: FavoriteTrip) async throws {
        // TODO: Implement your API call here
    }
}
