//
//  SearchItemLineGrid.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 29.06.25.
//

import SwiftUI

let COL_COUNT = 5

func createRowRange(_ lineCount: Int) -> Range<Int> {
    let rangeEnd = (lineCount-1) / COL_COUNT
    return 0..<rangeEnd
}

func createColRange(_ rowIndex: Int) -> Range<Int> {
    let rangeStart = rowIndex*COL_COUNT
    let rangeEnd = (rowIndex*COL_COUNT) + COL_COUNT
    return rangeStart..<rangeEnd
}

struct SearchItemLineGrid: View {
    let groupedAndSortedLines: [[StationSearchItemLine]]
    
    init(lines: [StationSearchItemLine]) {
        let groupedLines = Dictionary(grouping: lines, by: { $0.product })
        
        var groupedAndSortedLines: [[StationSearchItemLine]] = []
        
        groupedLines.values.forEach { linesForProduct in
            groupedAndSortedLines.append(linesForProduct.sorted { $0.name < $1.name })
        }
        
        self.groupedAndSortedLines = groupedAndSortedLines
    }
    
    var body: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 4) {
            ForEach(0..<groupedAndSortedLines.count) { rowIndex in
                GridRow {
                    ForEach(0..<groupedAndSortedLines[rowIndex].count) { columnIndex in
                        LineIcon(line: groupedAndSortedLines[rowIndex][columnIndex])
                    }
                }
            }
        }
    }
}

//#Preview {
//    SearchItemLineGrid()
//}
