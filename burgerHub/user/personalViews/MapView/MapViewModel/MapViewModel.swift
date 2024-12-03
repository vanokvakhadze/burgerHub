//
//  MapViewModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 21.11.24.
//

import SwiftUI
import MapKit



final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation:  CLLocationCoordinate2D?
    @Published var locations: [Location]
    @Published var sortedLocations: [Location] = []
    @Published var mapLocation: Location {
        didSet {
            sortLocationsByDistance()
            calculateRouteDetails(to: mapLocation)
        }
    }
    
    @Published var currentIndex = 0 {
        didSet {
            mapLocation = sortedLocations[currentIndex]
        }
    }
    
    @Published var cameraPosition: MapCameraPosition
    @Published var route: MKRoute?
    @Published var activeRoute: Bool = false
    
    private let locationManager = CLLocationManager()
    private let mapSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    
    override init() {
        let locations = MapLocation.location
        self.locations = locations
        self.mapLocation =  locations.first!
        self.cameraPosition = .region(
            MKCoordinateRegion(
                center: locations.first?.coordinates ?? CLLocationCoordinate2D(),
                span: mapSpan
            )
        )
        super.init()
        requestLocationAccess()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        updateMapRegion(location: mapLocation)
        
        
    }
    
    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: location.coordinates,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
        }
    }
    
    func tapToNextLocation(location: Location) {
        withAnimation {
            currentIndex = location.id - 1
            updateMapRegion(location: location)
        }
    }
    
    func swipeAction() {
        guard let currentIndex = sortedLocations.firstIndex(where: { $0 == mapLocation }) else { return }
        
        let nextIndex = currentIndex + 1
        
        withAnimation {
            if locations.indices.contains(nextIndex) {
                tapToNextLocation(location: locations[nextIndex])
               
            } else if let firstLocation = locations.first {
                tapToNextLocation(location: firstLocation)
               
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        self.userLocation = userLocation.coordinate
        
        
        sortLocationsByDistance()
    }
    
    func sortLocationsByDistance() {
        guard let userLocation = userLocation else { return }
        sortedLocations = self.locations.sorted {
            let distance1 = CLLocation(latitude: $0.coordinates.latitude, longitude: $0.coordinates.longitude)
                .distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude))
            let distance2 = CLLocation(latitude: $1.coordinates.latitude, longitude: $1.coordinates.longitude)
                .distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude))
            return distance1 < distance2
        }
    }
    
    func calculateRouteDetails(to location: Location) {
        guard let userLocation = userLocation else {
                    print("User location not available")
                    return
                }

                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinates))
                request.transportType = .any

                let directions = MKDirections(request: request)
                directions.calculate { [weak self] response, error in
                    if let error = error {
                        print("Error calculating route: \(error)")
                        return
                    }

                    guard let route = response?.routes.first else {
                        print("No route found")
                        return
                    }

                    DispatchQueue.main.async {
                        self?.route = route
                        self?.activeRoute = true
                    }
                }
    }
    
    
    
    func cancelRoute() {
        DispatchQueue.main.async {
            self.route = nil
            self.activeRoute = false
        }
    }
    
    
}


