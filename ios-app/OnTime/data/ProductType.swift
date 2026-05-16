//
//  ProductType.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 06.04.26.
//

enum ProductType: String, Codable, Comparable  {
    case suburban = "suburban"
    case subway = "subway"
    case tram = "tram"
    case bus = "bus"
    case ferry = "ferry"
    case express = "express"
    case regional = "regional"

    // we can explicitly use this as an "importance
    private var sortOrder: Int {
        switch self {
            case .ferry: return 0
            case .express: return 1
            case .regional: return 2
            case .suburban: return 3
            case .subway: return 4
            case .tram: return 5
            case .bus: return 6
        }
    }

    static func < (lhs: ProductType, rhs: ProductType) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}
