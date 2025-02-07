//
//  StopoverList.swift
//  Travel12
//
//  Created by Robin Beer on 06.02.25.
//

import SwiftUI

struct StopoverListView: View {
    let stopovers: [Stopover]
    let selectedStationId: String
    
    var body: some View {
        ScrollView {
            ForEach(stopovers.indices, id: \.self) { index in
                let stopover = stopovers[index]
                let isSelectedStation = stopover.stop.id == selectedStationId
                StopoverItem(stopover: stopover, isSelectedStation: isSelectedStation)
                if index < stopovers.count - 1 {
                    Divider()
                }
            }
        }
    }
}
