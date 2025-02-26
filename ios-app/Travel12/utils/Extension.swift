//
//  ColorExtension.swift
//  Travel12
//
//  Created by Robin Beer on 30.06.24.
//
import Foundation
import SwiftUI

extension String: Error {}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

func getContrastTextColor(_ baseColor: Color) -> Color {
    var r, g, b, a: CGFloat
    (r, g, b, a) = (0, 0, 0, 0)
    UIColor(baseColor).getRed(&r, green: &g, blue: &b, alpha: &a)
    let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return luminance < 0.6 ? .white : .black
}

extension Date {
    func secondsUntil(_ date: Date?) -> Int {
        if(date == nil) {
            return 0
        }
        let diff = Calendar.current.dateComponents([.second], from: self, to: date!)
        return diff.second ?? 0
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
