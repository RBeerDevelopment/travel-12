//
//  StationDepartureViewModel.swift
//  Travel12
//
//  Created by Robin Beer on 29.06.24.
//

import Combine
import SwiftUI

class StationDeparturesViewModel: ObservableObject {
    
    @Published var departures: [String: [Departure]] = [:]
    @Published var isLoading: Bool = false
    @Published var lineNames: [String] = []
    @Published var lines: [Line] = []
    
    private let apiHelper = CombineApiHelper()
    
    func fetchDepartures(for stationId: String) {
        let splitStationId = stationId.components(separatedBy: ":")
        
        let url = "\(API_BASE_URL)stops/\(splitStationId[2])/departures?duration=60&results=60&remarks=false&express=false"
        self.isLoading = true
        
        do {
            try apiHelper.fetchApiDataIntoCombine(
                from: url,
                to: DeparturesResponse.self,
                onReceive: {
                    print("onReceive")
                    self.isLoading = false
                },
                responseHandler: { [weak self] response in
                    let _departures = Dictionary(grouping: response.departures, by: { $0.line.name })
                    self?.departures = _departures
                    self?.lineNames = _departures.keys.sorted()
                    self?.lines = response.departures.map { departure in departure.line }
                    
                }
            )
        } catch {
            print(error)
        }
    }
}
