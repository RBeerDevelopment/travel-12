//
//  AddressSearchViewModel.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 01.05.25.
//

import MapKit

struct SearchCompletions: Identifiable {
    let id = UUID()
    let title: String
    let subTitle: String
    
    let lng: Double
    let lat: Double
}

@Observable
class AddressSearchViewModel: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter

    var completions = [SearchCompletions]()

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(queryFragment: String) {
        completer.resultTypes = [.address, .pointOfInterest]
        completer.queryFragment = queryFragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map { completion in
            // Get the private _mapItem property
            let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem
            
            return .init(
                title: completion.title,
                subTitle: completion.subtitle,
                lng: mapItem?.placemark.coordinate.longitude ?? 0,
                lat: mapItem?.placemark.coordinate.latitude ?? 0
            )
        }
    }
}
