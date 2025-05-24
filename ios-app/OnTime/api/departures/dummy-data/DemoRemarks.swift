//
//  DemoRemarks.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 20.05.25.
//

import Foundation

let demoWarningJSON: String = """
{
"id": "278804",
"type": "warning",
"summary": "Elevator out of service",
"text": "The lift at U Rosenthaler Platz (street &#60;  &#62; interemdiate level) station will be renewed until 04.06.2025. (valid at: U Rosenthaler Platz (Berlin))",
"icon": {
    "type": "HIM3",
    "title": null
},
"priority": 50,
"products": {
    "suburban": false,
    "subway": false,
    "tram": true,
    "bus": true,
    "ferry": false,
    "express": false,
    "regional": false
},
"company": "BVG",
"categories": [
    3
],
"validFrom": "2025-02-03T06:00:00+01:00",
"validUntil": "2025-06-04T06:00:00+02:00",
"modified": "2025-04-23T04:32:33+02:00"
}"
"""

var validFrom: Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss\'.000\'z"
    return dateFormatter.date(from: "2025-02-03T06:00:00+01:00") ?? Date()
}

var validUntil: Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss\'.000\'z"
    return dateFormatter.date(from: "2025-06-04T06:00:00+02:00") ?? Date()
}

let demoWarningRemark = WarningRemark(
    id: "test-warning",
    type: .warning,
    summary: "Elevator out of service",
    text: "The lift at U Rosenthaler Platz (street interemdiate level) station will be renewed until 04.06.2025. (valid at: U Rosenthaler Platz (Berlin))",
    priority: 100,
    products: Products(suburban: false, subway: false, tram: true, bus: true, ferry: false, express: false, regional: false),
    validFrom: validFrom,
    validUntil: validUntil,
    icon: nil
)

let demoTripHintRemark = HintRemark(
    code: "text.journeystop.product.or.direction.changes.journey.message",
    text: "From U Eberswalder Str. (Berlin) as M13 heading towards S Warschauer Straße"
)

