//
//  StationView.swift
//  Travel12
//
//  Created by Robin Beer on 28.06.24.
//

import Combine
import SwiftUI

struct StationView: View {
    let stationId: String
    let stationName: String

    @State var isFavorite = false
    @State var selectedLineName: String? = nil

    var selectedLine: Line? {
        if selectedLineName != nil {
            viewModel.lines.first(where: { $0.name == selectedLineName })
        } else {
            nil
        }
    }

    var showLinePicker: Bool {
        viewModel.lineNames.count > 1
    }

    var lineNameToShow: String? {
        if selectedLineName != nil {
            selectedLineName
        } else if viewModel.lineNames.count == 1 {
            viewModel.lineNames[0]
        } else {
            nil
        }
    }

    @StateObject private var viewModel = StationDeparturesViewModel()

    var body: some View {
        let departures = viewModel.departures
        let lineNames = viewModel.lineNames
        
        VStack(alignment: .leading) {
            
            if viewModel.isLoading {
                
                LoadingIndicator()
            } else {
                if showLinePicker {
                    LineSelectionSection(lineNames: lineNames, lines: viewModel.lines, selectedLineName: $selectedLineName)
                }
                if let lineName = lineNameToShow, let line = viewModel.lines.first(where: { $0.name == lineName }) {
                    SingleLineDepartures(departures: departures[lineName] ?? [], line: line, stationId: stationId, stationName: stationName)
                } else {
                    AllDepartureList(departures: departures, stationId: stationId, stationName: stationName, lines: viewModel.lines)
                }
            }
        }
        .navigationTitle(stationName)
        .onAppear {
            viewModel.fetchDepartures(for: stationId)
        }.onReceive(timer) { _ in
            viewModel.fetchDepartures(for: stationId)
        }
    }

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    }
}

#Preview {
    StationView(stationId: "900058101", stationName: "Frankfurter Allee")
}
