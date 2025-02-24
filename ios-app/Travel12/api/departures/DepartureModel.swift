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

struct DeparturesResponse: Decodable {
    var departures: [Departure]
    let realtimeDataUpdatedAt: Int
}

struct Departure: Decodable, Identifiable {
    let tripId: String
    let when: String?
    let plannedWhen: String
    let delay: Int?
    let platform: String?
    let direction: String
    let line: TransportLine
    
    var id: String { tripId }
    
    var formattedWhen: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: when ?? plannedWhen) else { return when ?? plannedWhen }
        
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var whenDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: when ?? plannedWhen)
        return date ?? Date(timeIntervalSince1970: 0)
    }
}

struct TransportLine: Decodable {
    let name: String
    let product: String
    let color: LineColor?
}

struct LineColor: Decodable {
    let fg: String
    let bg: String
}
