//
//  LineSelector.swift
//  Travel12
//
//  Created by Robin Beer on 30.06.24.
//

import SwiftUI

struct LineSelector: View {
    
    let lineName: String
    let isSelected: Bool
    let lineColor: LineColor
    
    var backgroundColor: Color {
        Color(hex: lineColor.bg)
    }
    
    var body: some View {
        Text(lineName).padding(.horizontal, isSelected ? 8 : 6).padding(.vertical, 4).background(backgroundColor).clipShape(.capsule).foregroundStyle(getContrastTextColor(backgroundColor)).font(.caption).opacity(isSelected ? 1 : 0.5)
            
    }
}

#Preview {
    LineSelector(lineName: "U5", isSelected: false, lineColor: LineColor(fg: "#ff00ff", bg: "#a2a2a2"))
}
