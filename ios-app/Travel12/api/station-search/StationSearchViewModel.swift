import Combine
import SwiftUI
import CoreLocation

class StationViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var stations: [StationSearchItem] = []
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let locationManager: LocationManager

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        
        // Observe search query updates
        $searchQuery
            .removeDuplicates()
            .sink { [weak self] query in
                self?.stations = self?.fetchStations(for: query) ?? []
                self?.updateDistance()
                self?.updateHeading()
            }
            .store(in: &cancellables)
        
        
        // Observe location updates
        locationManager.$userLocation
            .sink { [weak self] _ in
                self?.updateDistance()
            }
            .store(in: &cancellables)
        locationManager.$heading
            .sink { [weak self] _ in
                self?.updateHeading()
            }
            .store(in: &cancellables)
    }
    
    private func fetchStations(for query: String) -> [StationSearchItem] {
        isLoading = true
        stations = queryStationInDB(query: query)
        isLoading = false
        return stations
    }
    
    private func updateHeading() {
        if let heading = locationManager.heading, let userLocation = locationManager.userLocation {
            
            self.stations = stations.map { station -> StationSearchItem in
                let updatedStation = station
                let stationLocation = CLLocation(latitude: station.location.latitude, longitude: station.location.longitude)
                
                let angleToNorth = angleBetweenCoordinates(lat1: userLocation.coordinate.latitude, lng1: userLocation.coordinate.longitude, lat2: stationLocation.coordinate.latitude, lng2: stationLocation.coordinate.longitude)
                
                let angleToSelf = angleToNorth - heading
                
                updatedStation.angle = angleToSelf
                return updatedStation
            }
            
        }
    }

    private func updateDistance() {
        if let userLocation = locationManager.userLocation {
            self.stations = stations.map { station -> StationSearchItem in
                let updatedStation = station
                let stationLocation = CLLocation(latitude: station.location.latitude, longitude: station.location.longitude)
                
                updatedStation.distanceToUser = userLocation.distance(from: stationLocation)
                return updatedStation
            }
        }
    }
}
