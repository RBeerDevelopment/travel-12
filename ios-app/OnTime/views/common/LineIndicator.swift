//
//  LineIndicator.swift
//  OnTime
//
//  Created by Robin Beer on 19.01.25.
//

import SwiftUI

struct LineIndicator: View {
    let name: String
    let backgroundColor: Color
    let textColor: Color
    
    init(line: TransportLine) {
        self.name = line.name
        self.backgroundColor = Color(hex: line.color?.bg ?? "#cdcdcd")
        self.textColor = getContrastTextColor(self.backgroundColor)
    }
    
    init(name: String, backgroundColor: String) {
        self.name = name
        self.backgroundColor = Color(hex: backgroundColor)
        self.textColor = getContrastTextColor(self.backgroundColor)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
            
            Text(name)
                .font(.subheadline)
                .foregroundColor(textColor)
        }
    }
}
