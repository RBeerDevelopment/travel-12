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
    let remarks: [AnyRemark]?
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
    let adminCode, mode, product: String
    let productName: ProductType

    enum CodingKeys: String, CodingKey {
        case type, id, fahrtNr, name
        case linePublic = "public"
        case adminCode, mode, product
        case productName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
        fahrtNr = try container.decode(String.self, forKey: .fahrtNr)
        name = try container.decode(String.self, forKey: .name)
        linePublic = try container.decode(Bool.self, forKey: .linePublic)
        adminCode = try container.decode(String.self, forKey: .adminCode)
        mode = try container.decode(String.self, forKey: .mode)
        product = try container.decode(String.self, forKey: .product)

        let rawProductName = try container.decode(String.self, forKey: .productName)
        guard let parsed = ProductType(rawValue: rawProductName.lowercased()) else {
            throw DecodingError.dataCorruptedError(forKey: .productName, in: container, debugDescription: "Unknown product type: \(rawProductName)")
        }
        productName = parsed
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(fahrtNr, forKey: .fahrtNr)
        try container.encode(name, forKey: .name)
        try container.encode(linePublic, forKey: .linePublic)
        try container.encode(adminCode, forKey: .adminCode)
        try container.encode(mode, forKey: .mode)
        try container.encode(product, forKey: .product)
        try container.encode(productName, forKey: .productName)
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
    let remarks: [AnyRemark]?
}
