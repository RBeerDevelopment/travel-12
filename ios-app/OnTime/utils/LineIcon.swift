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
        Color(hex: line.color).pastel
    }

    var body: some View {
        Text("\(line.name)")
            .frame(minWidth: 28)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(.black)
            .background(lineColor)
            .cornerRadius(8)

            
    }
}

#Preview {
    HStack {
        LineIcon(line: StationSearchItemLine(name: "M13", color: "#ff1afa", product: .tram))
    }.frame(width: .infinity, height: 20)
}
