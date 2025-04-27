//
//  ProductIcon.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import SwiftUI

struct ProductIcon: View {
    let productType: StationProductType

    private var systemImageName: String {
        switch productType {
        case .suburban:
            return "tram.fill"
        case .subway:
            return "tram.fill.tunnel"
        case .tram:
            return "lightrail.fill"
        case .bus:
            return "bus.fill"
        case .regional:
            return "tram.fill"
        }
    }

    private var backgroundColor: Color {
        switch productType {
        case .suburban:
            return .green
        case .subway:
            return .blue
        case .tram:
            return .red
        case .bus:
            return .gray
        case .regional:
            return .red
        }
    }

    var body: some View {
        Image(systemName: systemImageName)
            .font(.system(size: 14))
            .foregroundColor(backgroundColor)
            .padding(.horizontal, 2)
    }
}

#Preview {
    HStack {
        ProductIcon(productType: .suburban)
        ProductIcon(productType: .subway)
        ProductIcon(productType: .tram)
        ProductIcon(productType: .bus)
    }.frame(width: .infinity, height: 20)
}
