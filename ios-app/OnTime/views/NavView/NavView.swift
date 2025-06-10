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
    @StateObject private var navigationViewModel = NavigationViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $position)
            NavSearchSheet()
        }
        .addToastSafeAreaObserver()
        .environmentObject(navigationViewModel)
    }
}

#Preview {
    NavView()
}
