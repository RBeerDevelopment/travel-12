//
//  NavView.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 01.05.25.
//

import SwiftUI
import MapKit

struct NavView: View {
    
    @State private var position = MapCameraPosition.automatic
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $position)
            NavSearchSheet()
        }
        .addToastSafeAreaObserver()
    }
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}

#Preview {
    NavView()
}
