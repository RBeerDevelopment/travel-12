//
//  StationSearchView.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import SwiftUI

struct StationSearchView: View {
    
    let stations: [Station]
    
    var body: some View {
        ScrollView {
            ForEach(stations) { station in
                NavigationLink(destination: {
                    <#code#>
                }) {
                    SearchItemView(station: station)
                }
            }
        }
    }
}

#Preview {
    StationSearchView(stations: [
        Station(type: "test", id: "1234", name: "Scharnweberstraße", products: StationProducts(suburban: false, subway: true, tram: false, bus: false)),
        Station(type: "test", id: "222", name: "Frankfurter Allee", products: StationProducts(suburban: true, subway: true, tram: true, bus: false))
    ])
}
