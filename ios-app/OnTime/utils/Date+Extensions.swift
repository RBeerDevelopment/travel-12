//
//  Date+Extensions.swift
//  OnTime
//
//  Created by Robin Beer on 19.04.25.
//
import SwiftUI

extension Date {
    var secondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970).rounded())
    }
    
    static func stringInXMinutes(_ min: Int) -> String {
        let date = Date.now.addingTimeInterval(Double(min) * 60)
        return date.ISO8601Format()
    }
    
    static func fromIsoString(dateStr: String) -> Date {
        if(dateStr.isEmpty) {
            return Date.distantPast
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        return dateFormatter.date(from: dateStr) ?? Date.distantPast
    }
}
