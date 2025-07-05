//
//  ProductIcon.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import SwiftUI

struct LineIcon: View {
    
    var line: StationSearchItemLine
    
    var lineColor: Color {
        Color(hex: line.color)
    }

    var body: some View {
        Text("\(line.name)")
            .frame(minWidth: 24)
            .font(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .foregroundStyle(getContrastTextColor(lineColor))
            .background(lineColor)
            .cornerRadius(6)

            
    }
}

#Preview {
    HStack {
        LineIcon(line: StationSearchItemLine(name: "M13", color: "#ff1afa", product: "tram"))
    }.frame(width: .infinity, height: 20)
}
