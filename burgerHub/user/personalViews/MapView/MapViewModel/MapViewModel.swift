//
//  MapViewModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 21.11.24.
//

import SwiftUI
import MapKit



final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation = CLLocationCoordinate2D(latitude: 41.781898, longitude: 44.797892)
    @Published var locations: [Location]
    
    //  @Published let defaultLocation = CLLocationCoordinate2D(latitude: 41.781898, longitude: 44.797892)
    
    @Published var mapLocation: Location
    
    
    @Published var currentIndex = 0 {
        didSet {
            mapLocation = locations[currentIndex]
            updateMapRegion(location: mapLocation)
        }
    }
    
    @Published var cameraPosition: MapCameraPosition
    @Published var route: MKRoute?
    @Published var activeRoute: Bool = false
    private var lastUpdateTime: Date?
    
    @Published var locationManager = CLLocationManager()
    private let mapSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    
    override init() {
        let locations = MapLocation.location
        self.locations = locations
        self.mapLocation =  locations.first!
        
        self.cameraPosition = .region(
            MKCoordinateRegion(
                center: locations.first?.coordinates ?? CLLocationCoordinate2D(latitude: 41.781898, longitude: 44.797892),
                span: mapSpan
            )
        )
        super.init()
        //  requestLocationAccess()
        //        locationManager.delegate = self
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        updateMapRegion(location: mapLocation)
        
        
    }
    
    
    
    func updateMapRegion(location: Location) {
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
        guard let index = locations.firstIndex(of: location) else { return }
        withAnimation {
            currentIndex = index
            updateMapRegion(location: location)
        }
    }
    
    func calculateRouteDetails(to location: Location) {
        
        
        let destinationPlacemark = MKPlacemark(coordinate: location.coordinates)
        
        let request = MKDirections.Request()
        request.source = .init(placemark: .init(coordinate: userLocation))
        request.destination = .init(placemark:  .init(placemark: destinationPlacemark))
        request.transportType = .automobile
        
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if let error = error {
                print("Failed to calculate route: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else {
                print("No routes available.")
                return
            }
            
            DispatchQueue.main.async {
                self?.route = route
                self?.activeRoute = true
                print("Route calculated successfully!")
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


