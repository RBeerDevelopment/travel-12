//
//  SearchItemLineGrid.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 29.06.25.
//

import SwiftUI

struct SearchItemLineGrid: View {
    let groupedAndSortedLines: [[StationSearchItemLine]]
    
    init(lines: [StationSearchItemLine]) {
        groupedAndSortedLines = groupAndSortLines(lines)
    }
    
    var body: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 4) {
            ForEach(groupedAndSortedLines, id: \.self) { linesForProduct in
                GridRow {
                    ForEach(linesForProduct) { line in
                        LineIcon(line: line)
                    }
                }
            }
        }
    }
}

#Preview {
    SearchItemLineGrid(lines: demoStations[0].lines)
}
