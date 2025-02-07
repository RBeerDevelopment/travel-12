//
//  ApiClient.swift
//  Travel12
//
//  Created by Robin Beer on 19.01.25.
//

import Foundation

actor ApiClient {
    static let shared = ApiClient()
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
}

//19833
