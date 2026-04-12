//
//  Departures.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 06.04.26.
//
import Foundation

let demoLineS3 = TransportLine(name: "S3", product: .suburban, color: LineColor(fg: "#fff", bg: "#0a3d85"))

let baseDeparture = Departure(tripId: "1", when: Date.now.ISO8601Format(), plannedWhen: Date.now.ISO8601Format(), delay: nil, platform: "3", direction: "Erkner", line: demoLineS3, cancelled: nil, remarks: nil)

let demoDepartures = [
    baseDeparture.withUpdatedWhen(Date.stringInXMinutes(1)),
    baseDeparture.withUpdatedWhen(Date.stringInXMinutes(4)),
    baseDeparture.withUpdatedWhen(Date.stringInXMinutes(6)),
    baseDeparture.withUpdatedWhen(Date.stringInXMinutes(10)),
    baseDeparture.withUpdatedWhen(Date.stringInXMinutes(15)),
]
