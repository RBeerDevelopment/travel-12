//
//  View+FavoriteAction.swift
//  OnTime
//
//  Created by Robin Beer on 08.02.25.
//

import SwiftUI

extension View {
    
    func favoriteActionSheet(
        lineId: String,
        stationId: String,
        destinationId: String,
        stationName: String,
        isFavorite: Bool,
        showToast: @escaping ((Bool) -> ())
    ) -> some View {
        self.swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                Task {
                    let isSuccess = FavoritesManager.shared.toggleFavorite(lineId: lineId, stationId: stationId, destinationId: destinationId, stationName: stationName)
                    showToast(isSuccess)
                }
            } label: {
                Label(
                    isFavorite ? "Remove Favorite" : "Add Favorite",
                    systemImage: isFavorite ? "star.slash" : "star"
                )
            }
            .tint(isFavorite ? .gray : .yellow)
        }
    }
}
