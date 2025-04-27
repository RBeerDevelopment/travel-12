//
//  Polyline.swift
//  OnTime
//
//  Created by Robin Beer on 07.02.25.
//

import Foundation

struct Polyline: Codable {
    let features: [PolylineFeature]
}

struct PolylineFeature: Codable {
    let geometry: PolylineGeometry
}

struct PolylineGeometry: Codable {
    let coordinates: [Double]
}
