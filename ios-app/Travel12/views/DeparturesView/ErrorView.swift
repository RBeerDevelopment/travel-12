//
//  ErrorView.swift
//  Travel12
//
//  Created by Robin Beer on 19.01.25.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error loading departures")
                .font(.headline)
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button("Retry", action: retryAction)
                .padding(.top)
        }
        .padding()
    }
}
