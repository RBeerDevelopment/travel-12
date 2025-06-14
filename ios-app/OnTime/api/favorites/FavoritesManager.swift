//
//  FavoriteManager.swift
//  OnTime
//
//  Created by Robin Beer on 08.02.25.
//

import SwiftUI
import SwiftData

@Observable
final class FavoritesManager {
    
    static var shared: FavoritesManager {
        guard let instance = _shared else {
            fatalError("""
                       FavoritesManager.shared used before it was configured.
                       Call FavoritesManager.configure(context:) once at startup.
                       """)
        }
        return instance
    }
    
    /// Call exactly **once**
   static func configure(context: ModelContext) {
       precondition(_shared == nil, "FavoritesManager.configure(_:) may only be called once")
       _shared = FavoritesManager(context: context)
   }
    
    // MARK: – Private
   private static var _shared: FavoritesManager?
   private let modelContext: ModelContext
   let apiClient = ApiClient.shared

   private init(context: ModelContext) {
       self.modelContext = context
   }
    
    func isFavorite(lineId: String, stationId: String, destinationId: String) -> Bool {
        let descriptor = FetchDescriptor<FavoriteTrip>(
            predicate: #Predicate<FavoriteTrip> { favorite in
                favorite.lineId == lineId && favorite.stationId == stationId && favorite.destinationId == destinationId
            }
        )
        let favoriteDescriptorCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        return favoriteDescriptorCount > 0
    }
    
    func toggleFavorite(lineId: String?, stationId: String?, destinationId: String?, stationName: String?) -> Bool {
        guard let lineId = lineId, let stationId = stationId, let destinationId = destinationId, let stationName = stationName else {
            return false
        }
        if isFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId) {
            return removeFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId)
        } else {
            return addFavorite(lineId: lineId, stationId: stationId, stationName: stationName, destinationId: destinationId)
        }
    }
    
    private func addFavorite(lineId: String, stationId: String, stationName: String, destinationId: String) -> Bool {
        do {
            let favorite = FavoriteTrip(lineId: lineId, stationId: stationId, destinationId: destinationId, stationName: stationName)
            modelContext.insert(favorite)
            try modelContext.save()
            
            Task {
                try await uploadToServer(favorite)
            }
            return true
        } catch {
            dump(error)
            return false
        }
    }
    
    private func removeFavorite(lineId: String, stationId: String, destinationId: String) -> Bool {
        do {
            let descriptor = FetchDescriptor<FavoriteTrip>(
                predicate: #Predicate<FavoriteTrip> { favorite in
                    favorite.lineId == lineId && favorite.stationId == stationId && favorite.destinationId == destinationId
                }
            )
            
            guard let favorite = try? modelContext.fetch(descriptor).first else { return false }
            
            modelContext.delete(favorite)
            try modelContext.save()
            
            Task {
                try await deleteFromServer(favorite.id)
            }
            return true
        } catch {
            dump(error)
            return false
        }
    }
    
    private func uploadToServer(_ favorite: FavoriteTrip) async throws {
        _ = try await apiClient.uploadFavoriteTrip(trip: favorite)
    }
    
    private func deleteFromServer(_ id: String) async throws {
        _ = try await apiClient.deleteFavoriteTrip(id)
    }
}

