//
//  TripCardModifier.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 21.05.25.
//

import SwiftUI

struct TripCardModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(colorScheme == .light ? .systemBackground : .secondarySystemBackground))
            .cornerRadius(10)
            .shadow(radius: 1)
    }
}
