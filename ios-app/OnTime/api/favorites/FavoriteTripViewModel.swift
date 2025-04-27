//
//  FavoriteTripViewModel.swift
//  OnTime
//
//  Created by Robin Beer on 13.02.25.
//


import Combine
import SwiftUI

struct FavoriteDepartureRequestData {
    var stationId: String
    var destination: String
    var id: String
}


actor DepartureTaskManager {
    private var currentTask: Task<Void, Never>?
    
    func startNewFetch(_ operation: @escaping () async throws -> Void) {
        // Cancel any existing task
        currentTask?.cancel()
        
        // Start new task
        currentTask = Task {
            try? await operation()
        }
    }
    
    func cancelCurrentTask() {
        currentTask?.cancel()
        currentTask = nil
    }
}

@MainActor
class FavoriteTripViewModel: ObservableObject {
    @Published var departures: [String: [Departure]] = [:]
    @Published var isLoading = false
    @Published var error: Error?
    
    private let taskManager = DepartureTaskManager()
    
    func fetchFavoriteDepartures(requestData: [FavoriteDepartureRequestData]) {
        Task {
            await taskManager.startNewFetch {
                self.isLoading = true
                self.error = nil
                
                do {
                    // Check for cancellation before starting
                    try Task.checkCancellation()
                    
                    let response = try await ApiClient.shared.fetchMultipleDepartures(requestData: requestData)
                    
                    // Check for cancellation before updating UI
                    try Task.checkCancellation()
                    
                    await MainActor.run {
                        self.departures = response
                        self.isLoading = false
                    }
                } catch is CancellationError {
                    await MainActor.run {
                        self.isLoading = false
                    }
                } catch {
                    await MainActor.run {
                        self.error = error
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func cancelFetch() {
        Task {
            await taskManager.cancelCurrentTask()
        }
    }
}
