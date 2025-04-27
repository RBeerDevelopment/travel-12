//
//  LoadingIndicator.swift
//  OnTime
//
//  Created by Robin Beer on 10.11.24.
//

import SwiftUI

struct LoadingIndicator: View {
    
    var body: some View {
            Image(systemName: "tram.fill")
                .symbolEffect(.breathe, options: .speed(1).repeat(100), isActive: true)
                .font(.system(size: 64))
                .foregroundStyle(Color("primary"))
                .padding()
    }
}

struct LargeLoadingIndicator: View {
    
    var body: some View {
        
        VStack(spacing: 16) {
            LoadingIndicator()
            Text("OnTime")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color("primary"))
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
    }
}

#Preview {
    LargeLoadingIndicator()
}
