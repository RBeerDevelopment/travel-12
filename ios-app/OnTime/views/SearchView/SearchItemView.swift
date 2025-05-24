//
//  SearchItemView.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import SwiftUI
import CoreLocation
import SwiftData

struct SearchItemView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @ObservedObject var station: StationSearchItem
    @State private var hasNavigated = false
    
    let formattedDistance: String?
    
    init(station: StationSearchItem) {
        self.station = station
        self.formattedDistance = formatDistance(station.distanceToUser)
    }
    
    var body: some View {
        // weird workaround for having an additional action when navigating
        NavigationLink(
            destination: DeparturesView(stationId: station.id.components(separatedBy: ":")[2], stationName: station.name),
            isActive: $hasNavigated,
            label: { EmptyView() }
        )
        Button {
            handleStationClick(station, context: modelContext)
            hasNavigated = true
        } label: {
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
                Spacer(minLength: 20)
                Image(systemName: "chevron.right")
                    .font(.callout)
                    .foregroundColor(.primary)
                    .padding(.leading)
            }
        }
        .padding(.vertical, 8)
        .buttonStyle(PlainButtonStyle())
        .buttonBorderShape(.roundedRectangle)
    }
}

func handleStationClick(_ station: StationSearchItem, context: ModelContext) {
    do {
        let allRecentSearchesDescriptor = FetchDescriptor<RecentSearchStation>(
            sortBy: [SortDescriptor(\.lastSearched, order: .reverse)]
        )
        
        var existingRecords = try context.fetch(allRecentSearchesDescriptor)
        
        if let existingRecord = existingRecords.first(where: { $0.id == station.id }) {
            existingRecord.lastSearched = Date()
        } else {
            context.insert(RecentSearchStation(from: station))
        }
        
        // refresh the existing records now that it has been updated
        existingRecords = try context.fetch(allRecentSearchesDescriptor)

        if existingRecords.count > RECENT_SEARCH_LIMIT {
            let entriesToDelete = existingRecords.dropFirst(RECENT_SEARCH_LIMIT)
            for entry in entriesToDelete {
                context.delete(entry)
            }
        }

        try context.save()
    } catch {
        print("Failed to fetch or delete entries: \(error)")
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
