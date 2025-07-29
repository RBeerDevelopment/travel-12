//
//  SearchStationResult.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//
import Foundation

struct StationSearchItemLine: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let color: String
    let product: String
    
    init(name: String, color: String, product: String) {
        self.id = name
        self.name = name
        self.color = color
        self.product = product
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .name)
        self.name = try container.decode(String.self, forKey: .name)
        self.color = try container.decode(String.self, forKey: .color)
        self.product = try container.decode(String.self, forKey: .product)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
        try container.encode(product, forKey: .product)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, color, product
    }
    
}

class StationSearchItem: Codable, Identifiable, Hashable, ObservableObject {
    let id: String
    let name: String
    let lines: [StationSearchItemLine]
    let location: Location
    @Published var distanceToUser: Double?
    @Published var angle: Double?
    
    init(id: String, name: String, lines: [StationSearchItemLine], location: Location) {
        self.id = id
        self.name = name
        self.lines = lines
        self.location = location
    }
    
    convenience init(snapshot: StationSnapshot) {
        self.init(id: snapshot.id, name: snapshot.name, lines: snapshot.lines, location: snapshot.location)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: StationSearchItem, rhs: StationSearchItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, lines, location
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        lines = try container.decode([StationSearchItemLine].self, forKey: .lines)
        location = try container.decode(Location.self, forKey: .location)
        // `distanceToUser` and `angle` are not decoded because they're set dynamically
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(lines, forKey: .lines)
        try container.encode(location, forKey: .location)
        // `distanceToUser` and `angle` are not encoded because they're set dynamically
    }
}

let demoStations = [
    StationSearchItem(id: "1023838", name: "U Scharnweberstraße", lines: [
        StationSearchItemLine(name: "U1", color: "#ff0011", product: "subway"),
        StationSearchItemLine(name: "U2", color: "#ff0011", product: "subway"),
        StationSearchItemLine(name: "U3", color: "#ff0011", product: "subway"),
        StationSearchItemLine(name: "U5", color: "#ff0011", product: "subway"),
        StationSearchItemLine(name: "U7", color: "#ff0011", product: "subway"),
        StationSearchItemLine(name: "U9", color: "#ff0011", product: "subway"),
        StationSearchItemLine(name: "RB14", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RB23", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RB24", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RE1", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RE2", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RE3", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RE4", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RE5", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RE7", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RE8", color: "#ff0011", product: "regional"),
        StationSearchItemLine(name: "RE9", color: "#ff0011", product: "regional"),
        ], location: Location(id: "123", latitude: 52.475465, longitude: 13.365575)),
    StationSearchItem(id: "222", name: "Frankfurter Allee", lines: [], location: Location(id: "123", latitude: 52.475465, longitude: 13.365575))
]

