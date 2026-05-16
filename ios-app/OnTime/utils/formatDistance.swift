//
//  formatDistance.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 12.04.26.
//

func formatDistance(_ distance: Double?) -> String? {
    if let distance = distance {
        let isMoreThanOneKm = distance > 1000
        let formattedDistance: String
        if isMoreThanOneKm {
            formattedDistance = String(format: "%.1fkm", distance / 1000)
        } else {
            formattedDistance = String(format: "%.0fm", distance)
        }
        return formattedDistance
    }
    return nil
}
