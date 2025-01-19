//
//  SearchItemView.swift
//  Travel12
//
//  Created by Robin Beer on 28.06.24.
//

import SwiftUI
import CoreLocation

struct SearchItemView: View {
    
    @ObservedObject var station: StationSearchItem
    let formattedDistance: String?
    
    init(station: StationSearchItem) {
        self.station = station
        self.formattedDistance = formatDistance(station.distanceToUser)
    }
    
    var body: some View {
        NavigationLink(destination: StationView(stationId: station.id, stationName: station.name)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(station.name).font(.headline)
                        .foregroundStyle(.primary)
                        
                    HStack {
                        ForEach(station.products, id: \.self) { productType in
                            ProductIcon(productType: StationProductType(rawValue: productType) ?? .bus)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                // this is a really annoying workaround
                // that seems to be necesssary to make everything clickable
                .background(.white.opacity(0.001))
                if let formattedDistance = formattedDistance {
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .rotationEffect(Angle.degrees((station.angle ?? 45) - 45))
                        Text(formattedDistance)
                            .foregroundStyle(.gray)
                            .font(.callout)
                    }
                    
                }
                HStack {
                    Spacer()
                }
                Image(systemName: "chevron.right")
                    .font(.callout)
                    .foregroundColor(.primary)
                    .padding(.leading)
            }.padding(.vertical, 8)
            
        }
        .buttonStyle(PlainButtonStyle())
        .buttonBorderShape(.roundedRectangle)
    }
    
    
}

func formatDistance(_ distance: Double?) -> String? {
    if let distance = distance {
        let isMoreThanOneKm = distance > 1000
        let formattedDistance: String
        if isMoreThanOneKm {
            formattedDistance = String(format: "%.1f km", distance / 1000)
        } else {
            formattedDistance = String(format: "%.0f m", distance)
        }
        return formattedDistance
    }
        
    return nil
    
}

#Preview {
    SearchItemView(station: demoStations[0])
}
