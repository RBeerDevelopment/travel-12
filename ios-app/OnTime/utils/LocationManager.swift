//
//  LocationManager.swift
//  OnTime
//
//  Created by Robin Beer on 28.06.24.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var heading: CLLocationDirection?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    // annoying workaround that needs to be removed
    private var userLocationSetCount = 0

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let distance = if let userLocation = userLocation {
            location.distance(from: userLocation)
        } else {
            Double.infinity
        }
        if(userLocationSetCount > 1 && distance < 5) {
            return
        }
        userLocation = location
        userLocationSetCount += 1
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if(newHeading.headingAccuracy < 0) {
            return
        }
        
        let heading: CLLocationDirection = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        
        // filter out minmal rotation changes
        if(self.heading != nil && abs(heading - self.heading!) < 5) {
            return
        }
        
        self.heading = heading
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        } else {
            manager.stopUpdatingLocation()
        }
    }
}
