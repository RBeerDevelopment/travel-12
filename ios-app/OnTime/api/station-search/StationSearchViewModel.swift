import Combine
import SwiftData
import SwiftUI
import CoreLocation

class StationViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    
    @Published var stations: [StationSearchItem] = []
    @Published var nearbyStation: [StationSearchItem] = []
    @Published var recentlySearchedStations: [StationSearchItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let locationManager: LocationManager
    private var modelContext: ModelContext

    init(locationManager: LocationManager, context: ModelContext) {
        self.locationManager = locationManager
        
        modelContext = context
        
        let fetchDescriptor = FetchDescriptor<RecentSearchStation>()
        do {
            let recentSearchSnapshots = try modelContext.fetch(fetchDescriptor)
        
            recentlySearchedStations = recentSearchSnapshots.map { StationSearchItem(snapshot: $0.stationSnapshot) }
        } catch {
            recentlySearchedStations = []
        }
        
        // Observe search query updates
        $searchQuery
            .removeDuplicates()
            .sink { [weak self] query in
                self?.stations = self?.fetchStations(for: query) ?? []
                self?.updateDistances()
                self?.updateHeadings()
            }
            .store(in: &cancellables)
        
        
        // Observe location updates
        locationManager.$userLocation
            .sink { [weak self] _ in
                self?.updateNearbyStations()
                self?.updateDistances()
            }
            .store(in: &cancellables)
        
        locationManager.$heading
            .sink { [weak self] _ in
                self?.updateHeadings()
            }
            .store(in: &cancellables)
    }
    
    private func fetchStations(for query: String) -> [StationSearchItem] {
        isLoading = true
        stations = queryStationInDB(query: query)
        isLoading = false
        return stations
    }
    
    private func updateHeadings() {
        guard let heading = locationManager.heading, let userLocation = locationManager.userLocation else { return }
        self.stations = stations.map { updateStationHeading($0, userLocation, heading) }
        self.nearbyStation = nearbyStation.map { updateStationHeading($0, userLocation, heading) }
        self.recentlySearchedStations = recentlySearchedStations.map { updateStationHeading($0, userLocation, heading) }
    }

    private func updateDistances() {
        guard let userLocation = locationManager.userLocation else { return }
        self.stations = stations.map { updateStationDistance($0, userLocation) }
        self.nearbyStation = nearbyStation.map { updateStationDistance($0, userLocation) }
        self.recentlySearchedStations = recentlySearchedStations.map { updateStationDistance($0, userLocation) }
    }
    
    private func updateStationDistance(_ station: StationSearchItem, _ userLocation: CLLocation) -> StationSearchItem {
        let updatedStation = station
        let stationLocation = CLLocation(latitude: station.location.latitude, longitude: station.location.longitude)
        
        updatedStation.distanceToUser = userLocation.distance(from: stationLocation)
        return updatedStation
    }
    
    private func updateStationHeading(
        _ station: StationSearchItem,
        _ userLocation: CLLocation,
        _ heading: CLLocationDirection
    ) -> StationSearchItem {
        let updatedStation = station
        let stationLocation = CLLocation(latitude: station.location.latitude, longitude: station.location.longitude)
        
        let angleToNorth = angleBetweenCoordinates(lat1: userLocation.coordinate.latitude, lng1: userLocation.coordinate.longitude, lat2: stationLocation.coordinate.latitude, lng2: stationLocation.coordinate.longitude)
        
        let angleToSelf = angleToNorth - heading
        
        updatedStation.angle = angleToSelf
        return updatedStation
    }
    
    private func updateNearbyStations() {
        guard let userLocation = locationManager.userLocation else { return }
        nearbyStation = queryNearbyStationsInDB(lat: userLocation.coordinate.latitude, lng: userLocation.coordinate.longitude)
    }

}
