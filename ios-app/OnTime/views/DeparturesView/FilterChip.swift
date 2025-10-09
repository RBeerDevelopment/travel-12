//
//  FilterChip.swift
//  OnTime
//
//  Created by Robin Beer on 26.02.25.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    let longPressAction: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title.capitalizingFirstLetter())
                .font(.subheadline)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(UIColor.systemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
                .gesture(
                    LongPressGesture(minimumDuration: 0.3)
                        .onEnded { _ in longPressAction() }
                )
        }
    }
}
