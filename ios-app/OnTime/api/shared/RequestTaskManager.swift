//
//  RequestTaskManager.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 30.05.25.
//

actor RequestTaskManager {
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
