//
//  ContentView.swift
//  OnTime
//
//  Created by Robin Beer on 27.06.24.
//

import SwiftUI

struct FavoritesView: View {
    
    @State private var showProfileSheet = false

    var body: some View {
        NavigationView {
            FavoriteDeparturesView()
                .navigationTitle("Favorites")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showProfileSheet = true
                        }) {
                            Image(systemName: "person.circle")
                                .font(.title2)
                                .foregroundStyle(.primary)
                        }
                    }
                }
        }
        .sheet(isPresented: $showProfileSheet) {
            ProfileView()
        }
        
    }
        
}

#Preview {
    FavoritesView()
}
