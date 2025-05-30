//
//  NavigationViewModel.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 30.05.25.
//

import Combine

struct NavigationRequestData {
    var start: SearchCompletion
    var destination: SearchCompletion
}

@MainActor
class NavigationViewModel: ObservableObject {
    var earlierRef, laterRef: String?
    @Published var journeys: [Journey] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let taskManager = RequestTaskManager()
    
    func fetchNavigationData(requestData: NavigationRequestData) {
        Task {
            await taskManager.startNewFetch {
                self.isLoading = true
                self.error = nil
                
                do {
                    defer {
                        self.isLoading = false
                    }
                    // Check for cancellation before starting
                    try Task.checkCancellation()
                    
                    let response = try await ApiClient.shared.fetchNavigationData(request: requestData)
                    
                    // Check for cancellation before updating UI
                    try Task.checkCancellation()
                    
                    print(response.journeys)
                    await MainActor.run {
                        self.journeys = response.journeys
                        self.earlierRef = response.earlierRef
                        self.laterRef = response.laterRef
                    }
                } catch is CancellationError {
                    print("Cancellation Error")
                } catch {
                    await MainActor.run {
                        self.error = error
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
