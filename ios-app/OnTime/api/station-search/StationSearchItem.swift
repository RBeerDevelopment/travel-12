//
//  SearchStationResult.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//
import Foundation

class StationSearchItem: Codable, Identifiable, Hashable, ObservableObject {
    let id: String
    let name: String
    let products: [String]
    let location: Location
    @Published var distanceToUser: Double?
    @Published var angle: Double?
    
    init(id: String, name: String, products: [String], location: Location) {
        self.id = id
        self.name = name
        self.products = products
        self.location = location
    }
    
    convenience init(snapshot: StationSnapshot) {
        self.init(id: snapshot.id, name: snapshot.name, products: snapshot.products, location: snapshot.location)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: StationSearchItem, rhs: StationSearchItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, products, location
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        products = try container.decode([String].self, forKey: .products)
        location = try container.decode(Location.self, forKey: .location)
        // `distanceToUser` and `angle` are not decoded because they're set dynamically
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(products, forKey: .products)
        try container.encode(location, forKey: .location)
        // `distanceToUser` and `angle` are not encoded because they're set dynamically
    }
}

enum StationProductType: String, CaseIterable, Identifiable {
    case suburban
    case subway
    case tram
    case bus
    case regional
    
    var id: String { rawValue }
}


let demoStations = [
    StationSearchItem(id: "1023838", name: "U Scharnweberstraße", products: ["tram"], location: Location(id: "123", latitude: 52.475465, longitude: 13.365575)),
    StationSearchItem(id: "222", name: "Frankfurter Allee", products: ["subway"], location: Location(id: "123", latitude: 52.475465, longitude: 13.365575))
]
