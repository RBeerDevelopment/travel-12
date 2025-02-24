//
//  ApiClient.swift
//  Travel12
//
//  Created by Robin Beer on 19.01.25.
//

import Foundation
import ClerkSDK

actor ApiClient {
    static let shared = ApiClient()
    private let clerk = Clerk.shared
    private let session = URLSession.shared
    private var cache: [String: (data: Any, timestamp: Date)] = [:]
    
    func fetchDepartures(stationId: String) async throws -> DeparturesResponse? {
        let endpoint = "https://v6.vbb.transport.rest/stops/\(stationId)/departures?duration=60&results=60&remarks=false&express=false"
        
        if let cached = cache[endpoint],
           Date().timeIntervalSince(cached.timestamp) < 30, // Cache for 30 seconds
           let data = cached.data as? DeparturesResponse {
            return data
        }
        
        let (data, _) = try await session.data(from: URL(string: endpoint)!)
        
        var decoded: DeparturesResponse? = nil
        do {
            decoded = try JSONDecoder().decode(DeparturesResponse.self, from: data)
        } catch {
            print(error)
        }
        
        if (decoded?.departures != nil) {
            let sortedDepartures = decoded?.departures.sorted {
                $0.whenDate < $1.whenDate
            }
            decoded?.departures = sortedDepartures ?? []
        }
        
        cache[endpoint] = (decoded, Date())
        return decoded
    }
    
    func fetchMultipleDepartures(requestData: [FavoriteDepartureRequestData]) async throws -> [String: [Departure]] {
        
            
            
            func fetchWithRetry(request: FavoriteDepartureRequestData, maxRetries: Int = 3) async throws -> (String, [Departure]) {
                var lastError: Error?
                
                for attempt in 0..<maxRetries {
                    try Task.checkCancellation()
                    
                    do {
                        let endpoint = "https://v6.vbb.transport.rest/stops/\(request.stationId)/departures"
                        
                        print(endpoint)
                        var urlComponents = URLComponents(string: endpoint)!
                        
                        urlComponents.queryItems = [
                            URLQueryItem(name: "duration", value: "60"),
                            URLQueryItem(name: "results", value: "60"),
                            URLQueryItem(name: "remarks", value: "false"),
                            URLQueryItem(name: "express", value: "false")
                        ]
                        
                        guard let url = urlComponents.url else {
                            throw URLError(.badURL)
                        }
                        
                        var urlRequest = URLRequest(url: url)
                        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
                        urlRequest.timeoutInterval = 30
                        
                        if attempt > 0 {
                            try await Task.sleep(nanoseconds: UInt64(0.5 * Double(attempt) * 1_000_000_000))
                        }
                        
                        let (data, response) = try await session.data(for: urlRequest)
                        
                        guard let httpResponse = response as? HTTPURLResponse,
                              (200...299).contains(httpResponse.statusCode) else {
                            throw URLError(.badServerResponse)
                        }
                        
                        let decoded = try JSONDecoder().decode(DeparturesResponse.self, from: data)
                        let filteredDepartures = decoded.departures.filter { $0.direction == request.destination }.sorted { $0.whenDate < $1.whenDate }
                        return (request.id, filteredDepartures)
                        
                    } catch is CancellationError {
                        throw CancellationError()
                    } catch {
                        lastError = error
                        if attempt < maxRetries - 1 {
                            continue
                        }
                        throw error
                    }
                }
                
                throw lastError ?? URLError(.unknown)
            }
            
            return try await withThrowingTaskGroup(of: (String, [Departure]).self) { group in
                var results: [String: [Departure]] = [:]
                results.reserveCapacity(requestData.count)
                
                // Add all requests to the group
                for request in requestData {
                    group.addTask {
                        try await fetchWithRetry(request: request)
                    }
                }
                
                // Collect results
                for try await (id, departures) in group {
                    results[id] = departures
                }
                
                return results
            }
        }
    
    func fetchTrip(tripId: String) async throws -> TripResponse? {
        let endpoint = "https://v6.vbb.transport.rest/trips/\(tripId)?remarks=false&pretty=false&polyline=true"
        // TODO add polyline

        if let cached = cache[endpoint],
           Date().timeIntervalSince(cached.timestamp) < 30, // Cache for 30 seconds
           let data = cached.data as? TripResponse {
            return data
        }
        
        
        let (data, _) = try await session.data(from: URL(string: endpoint)!)
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        var decoded: TripResponse? = nil
        do {
            decoded = try decoder.decode(TripResponse.self, from: data)
        } catch {
            print(error)
        }
        
        cache[endpoint] = (decoded, Date())
        return decoded
    }
    
    func uploadFavoriteTrip(trip: FavoriteTrip) async throws -> Bool {
        let endpoint = URL(string: "https://t12-api.vercel.app/api/favorite-trips")!
        if let userId = await clerk.user?.id {
            let body = [
                "id": trip.id,
                "userId": userId,
                "lineId": trip.lineId,
                "stationId": trip.stationId,
                "stationName": trip.stationName,
                "destinationId": trip.destinationId
            ]
            
            var request = URLRequest(url: endpoint)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONEncoder().encode(body)
                let (_, response) = try await session.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return true
            } catch {
                print("error uploading favorite trip")
                return false
            }
            
            
        }
        return false
    }
    
    func deleteFavoriteTrip(_ tripId: String) async throws -> Bool {
        let endpoint = URL(string: "https://t12-api.vercel.app/api/favorite-trips/\(tripId)")!
        if let userId = await clerk.user?.id {
            var request = URLRequest(url: endpoint)
            request.httpMethod = "DELETE"

            do {
                let (_, response) = try await session.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return true
            } catch {
                print("error uploading favorite trip")
                return false
            }
            
            
        }
        return false
    }
}

