//
//  LineSelectionSection.swift
//  Travel12
//
//  Created by Robin Beer on 07.07.24.
//

import SwiftUI

struct LineSelectionSection: View {
    
    let lineNames: [String]
    let lines: [Line]
    
    @Binding var selectedLineName: String?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(lineNames, id: \.self) { lineName in
                    Button {
                        if selectedLineName == lineName {
                            self.selectedLineName = nil
                        } else {
                            self.selectedLineName = lineName
                        }
                    } label: {
                        LineSelector(lineName: lineName, isSelected: selectedLineName == lineName, lineColor: lines.first(where: { $0.name == lineName })?.color ?? LineColor(fg: "#000", bg: "#a3a3a3"))
                    }
                }
            }.padding()
        }
    }
}
