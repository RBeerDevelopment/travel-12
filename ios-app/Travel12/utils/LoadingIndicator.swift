//
//  LoadingIndicator.swift
//  Travel12
//
//  Created by Robin Beer on 10.11.24.
//

import SwiftUI

struct LoadingIndicator: View {
    
    var body: some View {
        Image(systemName: "tram.fill")
            .symbolEffect(.breathe, options: .speed(1).repeat(100), isActive: true)
            .font(.largeTitle)
            .padding()
    }
}
