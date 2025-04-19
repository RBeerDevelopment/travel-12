//
//  Date+Extensions.swift
//  Travel12
//
//  Created by Robin Beer on 19.04.25.
//
import SwiftUI

extension Date {
    var secondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970).rounded())
    }
}
