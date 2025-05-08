//
//  TabView.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 01.05.25.
//

import SwiftUI

struct TabWrapperView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Departures", systemImage: "clock")
                }

            NavView()
                .tabItem {
                    Label("Navigation", systemImage: "arrow.trianglehead.turn.up.right.circle")
                }
        }
    }
}

#Preview {
    TabWrapperView()
}
