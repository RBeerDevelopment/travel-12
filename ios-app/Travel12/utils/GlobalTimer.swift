//
//  GlobalTimer.swift
//  Travel12
//
//  Created by Robin Beer on 24.11.24.
//

import Combine
import Foundation

// A global 10 second timer that can be subscribed to by all views that need to periodically update
class GlobalTenSecondTimer {
    static let shared = GlobalTenSecondTimer()

    let timerPublisher: Publishers.Autoconnect<Timer.TimerPublisher>

    private init() {
        timerPublisher = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    }
}
