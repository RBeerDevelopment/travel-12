//
//  Item.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
