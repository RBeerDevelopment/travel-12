//
//  ContentView.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//

import SwiftUI

struct FavoritesView: View {

    var body: some View {
        FavoriteDeparturesView()
            .navigationTitle("Favorites")
            .addToastSafeAreaObserver()
    }
        
}

#Preview {
    FavoritesView()
}
