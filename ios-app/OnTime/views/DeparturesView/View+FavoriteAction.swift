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
    
    func bounceHint(hintCount: Binding<Int>, offset: Binding<CGFloat>, distance: CGFloat = -32, index: Int) -> some View {
        self.onAppear {
            
            if(hintCount.wrappedValue > 2 || index != 0) {
                return
            }
            hintCount.wrappedValue += 1
            
            
            // animate left
            animateOffsetAsync(offset: offset, distance: distance, delay: 0.2)
            
            // animate back
            animateOffsetAsync(offset: offset, distance: 0, delay: 0.8)

        }
    }
}

func animateOffsetAsync(offset: Binding<CGFloat>, distance: CGFloat, delay: Double) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.4)) {
            offset.wrappedValue = distance
        }
    }
}
