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
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(backgroundColor)
            
            Text(name)
                .font(.subheadline)
                .foregroundColor(textColor)
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        LineIndicator(line: TransportLine(name: "S3", product: "suburban", color: LineColor(fg: "#fff", bg: "#0a3d85")))
            .frame(width: 40, height: 40)
        LineIndicator(line: TransportLine(name: "U6", product: "subway", color: LineColor(fg: "#fff", bg: "#7b3da0")))
            .frame(width: 40, height: 40)
        LineIndicator(name: "M10", backgroundColor: "#c9a30a")
            .frame(width: 40, height: 40)
    }
    .padding()
}
