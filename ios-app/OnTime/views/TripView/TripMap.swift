//
//  TripMap.swift
//  OnTime
//
//  Created by Robin Beer on 07.02.25.
//

import SwiftUI
import MapKit

struct TripMap: View {
    
    let polylineFeatures: [PolylineFeature]
    let lineColor: String
    
    var body: some View {
        
        let polylineCoordinates = polylineFeatures.map { $0.geometry.coordinates }
        let tripRoute: [CLLocationCoordinate2D] = polylineCoordinates.map { coordinates in
            CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        }
        VStack {
            Map {
                if let startCoordinates = tripRoute.first {
                    Marker("Start", systemImage: "chevron.right", coordinate: startCoordinates)
                        .tint(Color(hex: lineColor))
                }
                MapPolyline(coordinates: tripRoute)
                    .stroke(Color(hex: lineColor), lineWidth: 4)
                if let endCoordinates = tripRoute.last {
                    Marker("End", systemImage: "flag.pattern.checkered", coordinate: endCoordinates)
                        .tint(Color(hex: lineColor))
                }
            }
        }
        .cornerRadius(8)
    }
}

//#Preview {
//    TripMap()
//}
