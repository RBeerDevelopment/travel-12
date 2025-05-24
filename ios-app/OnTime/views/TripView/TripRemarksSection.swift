//
//  TripRemarksSection.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 20.05.25.
//

import SwiftUI

struct TripRemarksSection: View {
    
    let remarks: [AnyRemark]?
    
    var body: some View {
        if let remarks = remarks {
            let filteredRemarks = remarks.filter {
                $0.text != "BVG" &&
                !($0.text?.contains("Bicycle") ?? false)
            }
            
            if(filteredRemarks.isEmpty) {
                EmptyView()
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundStyle(.yellow)
                        Text("Warnings")
                            .font(.title3)
                        Spacer()
                    }
                    ForEach(filteredRemarks) { remark in
                        Text(remark.text ?? "")
                            .font(.subheadline)
                            .padding(.leading)
                    }
                }
                .modifier(TripCardModifier())
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    let anyRemarks = [demoTripHintRemark].toAnyRemarks()
    VStack {
        TripRemarksSection(remarks: anyRemarks)
        Spacer()
    }
}
