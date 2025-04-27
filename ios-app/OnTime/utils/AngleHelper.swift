//
//  AngleHelper.swift
//  OnTime
//
//  Created by Robin Beer on 12.11.24.
//

import Foundation

func angleBetweenCoordinates(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
    let deltaLng = lng2 - lng1
    
    // Convert latitude and longitude from degrees to radians
    let lat1Rad = lat1 * .pi / 180
    let lat2Rad = lat2 * .pi / 180
    let deltaLngRad = deltaLng * .pi / 180
    
    // Calculate the bearing angle
    let y = sin(deltaLngRad) * cos(lat2Rad)
    let x = cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(deltaLngRad)
    let angleRad = atan2(y, x)
    
    // Convert the result from radians to degrees
    var angleDeg = angleRad * 180 / .pi
    
    // Normalize the angle to [0, 360] degrees
    if angleDeg < 0 {
        angleDeg += 360
    }
    
    return angleDeg
}
