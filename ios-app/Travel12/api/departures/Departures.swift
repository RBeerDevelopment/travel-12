//
//  Departures.swift
//  Travel12
//
//  Created by Robin Beer on 29.06.24.
//

import Foundation

func removeSUPrefix(in input: String?) -> String? {
    if let text = input {
        let pattern = "(S |U |S\\+U )"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
    } else {
        return nil
    }
}


struct DeparturesResponse: Codable {
    let departures: [Departure]
    let realtimeDataUpdatedAt: Int
}

struct Departure: Codable, Identifiable, Hashable {
    let tripId: String
    let stop: Destination
    let when, plannedWhen: Date?
    let delay: Int?
    let platform, plannedPlatform, prognosisType, direction: String?
    let line: Line
//    let remarks: [Remark]
    let destination: Destination?
    let currentTripPosition: Tion?
    
    var id: String {
        tripId
    }
    
    init(tripId: String, stop: Destination, when: Date?, plannedWhen: Date?, delay: Int?, platform: String?, plannedPlatform: String?, prognosisType: String?, direction: String?, line: Line, destination: Destination?, currentTripPosition: Tion?) {
        self.tripId = tripId
        self.stop = stop
        self.when = when
        self.plannedWhen = plannedWhen
        self.delay = delay
        self.platform = platform
        self.plannedPlatform = plannedPlatform
        self.prognosisType = prognosisType
        self.direction = removeSUPrefix(in: direction)
        self.line = line
        self.destination = destination
        self.currentTripPosition = currentTripPosition
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tripId = try container.decode(String.self, forKey: .tripId)
        self.stop = try container.decode(Destination.self, forKey: .stop)
        self.when = try container.decodeIfPresent(Date.self, forKey: .when)
        self.plannedWhen = try container.decodeIfPresent(Date.self, forKey: .plannedWhen)
        self.delay = try container.decodeIfPresent(Int.self, forKey: .delay)
        self.platform = try container.decodeIfPresent(String.self, forKey: .platform)
        self.plannedPlatform = try container.decodeIfPresent(String.self, forKey: .plannedPlatform)
        self.prognosisType = try container.decodeIfPresent(String.self, forKey: .prognosisType)
        self.direction = try removeSUPrefix(in: container.decodeIfPresent(String.self, forKey: .direction))
        self.line = try container.decode(Line.self, forKey: .line)
        self.destination = try container.decodeIfPresent(Destination.self, forKey: .destination)
        self.currentTripPosition = try container.decodeIfPresent(Tion.self, forKey: .currentTripPosition)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Departure, rhs: Departure) -> Bool {
        return lhs.id == rhs.id
    }

}

struct Tion: Codable {
    let latitude, longitude: Double
    let id: String?
}

struct Destination: Codable {
    let id, name: String
    let location: Tion
    let products: Products
    let stationDHID: String
}

struct Products: Codable {
    let suburban, subway, tram, bus, ferry, express, regional: Bool
}

struct Line: Codable {
    let type, id, fahrtNr, name: String
    let linePublic: Bool
    let adminCode, productName, mode, product: String
    let lineOperator: Operator
    let color: LineColor?

    enum CodingKeys: String, CodingKey {
        case type, id, fahrtNr, name, adminCode, productName, mode, product, color
        case linePublic = "public"
        case lineOperator = "operator"
    }
}

struct LineColor: Codable {
    let fg, bg: String
}

struct Operator: Codable {
    let type, id, name: String
}

let exampleLine = Line(type: "subway", id: "1", fahrtNr: "12", name: "U5", linePublic: true, adminCode: "123", productName: "U5", mode: "test", product: "subway", lineOperator: Operator(type: "BVG", id: "12", name: "test"), color: LineColor(fg: "#123", bg: "f00"))

let exampleDeparture = Departure(tripId: "123", stop: Destination(id: "123", name: "Hauptbahnhof", location: Tion(latitude: 123.22, longitude: 123.22, id: "123"), products: Products(suburban: false, subway: true, tram: false, bus: false, ferry: false, express: false, regional: false), stationDHID: "123"), when: Date(), plannedWhen: Date().addingTimeInterval(TimeInterval(5)), delay: 2, platform: "1", plannedPlatform: "2", prognosisType: "?", direction: "abc", line: exampleLine, destination: Destination(id: "123", name: "Hauptbahnhof", location: Tion(latitude: 123.22, longitude: 123.22, id: "123"), products: Products(suburban: false, subway: true, tram: false, bus: false, ferry: false, express: false, regional: false), stationDHID: "123"), currentTripPosition: Tion(latitude: 123, longitude: 123, id: "1"))

//// MARK: - Remark
//struct Remark: Codable {
//    let type: String
//    let code: String?
//    let text: String
//    let id, summary: String?
//    let icon: Icon?
//    let priority: Int?
//    let products: Products?
//    let company: String?
//    let categories: [Int]?
//    let validFrom, validUntil, modified: Date?
//}
