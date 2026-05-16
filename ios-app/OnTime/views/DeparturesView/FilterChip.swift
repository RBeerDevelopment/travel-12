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
    let backgroundColor: Color
    let longPressAction: () -> Void
    
    init(title: String, isSelected: Bool, action: @escaping () -> Void, longPressAction: @escaping () -> Void, backgroundColor: Color? = nil) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
        self.longPressAction = longPressAction
        self.backgroundColor = backgroundColor ?? .accentColor
    }
    
    var productIconName: String? {
        guard let productType = ProductType(rawValue: title) else { return nil }
        return getProductIconName(productType)
    }
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if(productIconName != nil) {
                    Image(systemName: productIconName!)
                        .font(.system(size: 14))
                }
                Text(title.capitalizingFirstLetter())
                    .font(.system(size: 12, weight: .bold))
                    
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(isSelected ? backgroundColor : Color(UIColor.systemBackground))
        .foregroundColor(isSelected ? .white : .primary)
        .cornerRadius(24)
        .gesture(
            LongPressGesture(minimumDuration: 0.3)
                .onEnded { _ in longPressAction() }
        )
    }
}
