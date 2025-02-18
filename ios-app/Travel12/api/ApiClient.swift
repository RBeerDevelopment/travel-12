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
        let endpoint = "https://vbb-rest.fly.dev/stops/\(stationId)/departures?duration=60&results=60&remarks=false&express=false"

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
        
        cache[endpoint] = (decoded, Date())
        return decoded
    }
    
    func fetchMultipleDepartures(requestData: [FavoriteDepartureRequestData]) async throws -> [String: [Departure]] {
        var results: [String: [Departure]] = [:]
            
        // Create concurrent tasks for each station
        try await withThrowingTaskGroup(of: (String, [Departure]?).self) { group in
            // Add a task for each station ID
            for request in requestData {
                group.addTask {
                    let endpoint = "https://vbb-rest.fly.dev/stops/\(request.stationId)/departures?duration=60&results=60&remarks=false&express=false"
                    
                    print(endpoint)
                    let (data, _) = try await self.session.data(from: URL(string: endpoint)!)
                    
                    var decoded: DeparturesResponse? = nil
                    do {
                        decoded = try JSONDecoder().decode(DeparturesResponse.self, from: data)
                    } catch {
                        print(error)
                    }
                    return (request.id, decoded?.departures.filter({ $0.direction == request.destination }) ?? [])
                }
            }
            
            // Collect results as they complete
            for try await (id, response) in group {
                if let response = response {
                    results[id] = response
                }
            }
        }
        
        return results
    }
    
    func fetchTrip(tripId: String) async throws -> TripResponse? {
        let endpoint = "https://vbb-rest.fly.dev/trips/\(tripId)?remarks=false&pretty=false&polyline=true"
        // TODO add polyline
        
        print(endpoint)

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

