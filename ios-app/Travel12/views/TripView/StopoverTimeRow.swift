//
//  StopoverTimeView.swift
//  Travel12
//
//  Created by Robin Beer on 06.02.25.
//

import SwiftUI

struct StopoverTimeRow: View {
    let title: String
    let planned: Date
    let actual: Date
    let delay: Int?
    let platform: String?
    let plannedPlatform: String?
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(width: 80, alignment: .leading)
                
                HStack(spacing: 4) {
                    Text(formatTime(planned))
                        .strikethrough(planned != actual)
                        .foregroundColor(planned != actual ? .secondary : .primary)
                    
                    if planned != actual {
                        Text(formatTime(actual))
                    }
                    
                    if let delay = delay, delay > 0 {
                        Text("+\(delay / 60) min")
                            .foregroundColor(.red)
                    }
                }
                .font(.subheadline)
                .frame(idealWidth: 400)
            }
            Spacer()
            
            if let platform = platform {
                Text("Plt. \(platform.replacingOccurrences(of: "Pos. ", with: ""))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: 56)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
