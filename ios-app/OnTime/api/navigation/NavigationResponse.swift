//
//  NavigationResponse.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 30.05.25.
//

import Foundation

struct NavigationResponse: Codable {
    let earlierRef, laterRef: String
    let journeys: [Journey]
    let realtimeDataUpdatedAt: Int
}

struct Journey: Codable {
    let type: String
    let legs: [Leg]
    let refreshToken: String
    let cycle: Cycle
}

struct Cycle: Codable {
    let min: Int
    let max: Int?
    let nr: Int?
}

struct Leg: Codable {
    let origin, destination: NavigationDestination
    let departure, plannedDeparture: Date
    let departureDelay: Int?
    let arrival, plannedArrival: Date
    let arrivalDelay: Int?
    let legPublic, walking: Bool?
    let distance: Int?
    let reachable: Bool?
    let polyline: Polyline?
    let tripID: String?
    let line: Line?
    let direction, arrivalPlatform, plannedArrivalPlatform, arrivalPrognosisType: String?
    let departurePlatform, plannedDeparturePlatform, departurePrognosisType: String?
    let remarks: [AnyRemark]?
    let cycle: Cycle?
    let currentLocation: Location?

    enum CodingKeys: String, CodingKey {
        case origin, destination, departure, plannedDeparture, departureDelay, arrival, plannedArrival, arrivalDelay
        case legPublic = "public"
        case walking, distance, reachable, polyline
        case tripID = "tripId"
        case line, direction, arrivalPlatform, plannedArrivalPlatform, arrivalPrognosisType, departurePlatform, plannedDeparturePlatform, departurePrognosisType, remarks, cycle, currentLocation
    }
}

struct NavigationDestination: Codable {
    let id, name, stationDHID, address: String?
    let location: Location?
    let products: Products?
    let latitude, longitude: Double?
}
