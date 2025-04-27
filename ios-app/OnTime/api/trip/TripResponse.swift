//
//  TripResponse.swift
//  OnTime
//
//  Created by Robin Beer on 06.02.25.
//

import Foundation

struct TripResponse: Codable {
    let trip: Trip
    let realtimeDataUpdatedAt: Int
}

// MARK: - Trip
struct Trip: Codable {
    let origin, destination: Destination
    let departure, arrival: Date?
    let plannedDeparture, plannedArrival: Date?
    let departureDelay, arrivalDelay : Int?
    let line: Line
    let direction: String
    let arrivalPlatform, plannedArrivalPlatform: String?
    let arrivalPrognosisType, departurePrognosisType:  String?
    let departurePlatform, plannedDeparturePlatform: String?
    let stopovers: [Stopover]
    let cancelled: Bool?
    let id: String
    let polyline: Polyline?
}

struct Destination: Codable {
    let id, name: String
    let location: Location
    let products: Products
}

struct Products: Codable {
    let suburban, subway, tram, bus, ferry, express, regional: Bool
}

struct Line: Codable {
    let type, id, fahrtNr, name: String
    let linePublic: Bool
    let adminCode, productName, mode, product: String


    enum CodingKeys: String, CodingKey {
        case type, id, fahrtNr, name
        case linePublic = "public"
        case adminCode, productName, mode, product
    }
}

struct Stopover: Codable {
    let stop: Destination
    let arrival, departure: Date?
    let plannedArrival, plannedDeparture: Date?
    let arrivalDelay, departureDelay: Int?
    let arrivalPlatform, departurePlatform: String?
    let arrivalPrognosisType, departurePrognosisType: String?
    let plannedArrivalPlatform, plannedDeparturePlatform: String?
    let cancelled: Bool?
}
