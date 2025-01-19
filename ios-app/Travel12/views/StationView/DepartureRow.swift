//
//  DepartureRow.swift
//  Travel12
//
//  Created by Robin Beer on 07.07.24.
//

import SwiftUI

struct DepartureTimeRow: View {
    
    let departureTime: Date
    let diffText: String
    let delay: Int
    
    @State var now: Date
    
    init(departureTime: Date, delay: Int) {
        self.now = Date()
        self.departureTime = departureTime
        self.delay = delay
        let secondsUntilDeparture = Date().secondsUntil(departureTime)
        self.diffText = secondsUntilDeparture < 30 && secondsUntilDeparture > -30 ? "now" : secondsUntilDeparture < -60 ? " \(secondsUntilDeparture / 60)min ago" : "in \(secondsUntilDeparture / 60)min"
    }
    
    var body: some View {
        HStack {
            Text(diffText).fontWeight(.semibold)
                .foregroundStyle(delay > 0 ? .red : .primary).frame(minWidth: 80, alignment: .leading)
            Text(departureTime, style: .time)
        }.padding(.horizontal)
        .onReceive(GlobalTenSecondTimer.shared.timerPublisher) { _ in
                /// TODO  think about checking if anything changed first
                now = Date()
                
            }
    }
        
}

#Preview {
    DepartureTimeRow(departureTime: Date(), delay: 5)
}
