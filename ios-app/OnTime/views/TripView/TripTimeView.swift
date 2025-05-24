//
//  TripTimeView.swift
//  OnTime
//
//  Created by Robin Beer on 06.02.25.
//

import SwiftUI

struct TripTimeView: View {
    let title: String
    let planned: Date?
    let actual: Date?
    let delay: Int?
    let platform: String?
    let plannedPlatform: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
            
            HStack {
                Spacer()
                if let planned = planned {
                    Text(formatTime(planned))
                        .font(.headline)
                        .strikethrough(actual != planned)
                        .foregroundColor(actual != planned ? .secondary : .primary)
                }
                if actual != planned {
                    if let actual = actual {
                        Text(formatTime(actual))
                            .font(.headline)
                    }
                }
                
                if let delay = delay, delay > 0 {
                    Text("+\(delay / 60) min")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
            }.frame(maxWidth: .infinity)
            
            if let platform = platform {
                HStack {
                    Text("Platform:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(platform)
                        .font(.subheadline)
                }
            }
        }.frame(maxWidth: .infinity)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
