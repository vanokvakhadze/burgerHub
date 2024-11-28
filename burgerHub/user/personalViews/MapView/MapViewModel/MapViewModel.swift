//
//  MapViewModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 21.11.24.
//

import SwiftUI
import MapKit



final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
    @Published var locations: [Location] 
    @Published var mapLocation: Location {
        didSet{
            updateMapRegion(location: mapLocation)
        }
    }
    @Published var currentIndex = 0 {
        didSet {
            mapLocation = locations[currentIndex]
        }
    }
    
    @Published var cameraPosition: MapCameraPosition
    
    private var region: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    override init() {
        let locations = MapLocation.location
        self.locations = locations
        self.mapLocation = MapLocation.location.first!
        self.cameraPosition = .region(
                    MKCoordinateRegion(
                        center: locations.first!.coordinates,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    )
                )
        super.init()
        self.updateMapRegion(location: locations.first!)
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut){
            cameraPosition = .region(
                           MKCoordinateRegion(
                               center: location.coordinates,
                               span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                           )
                       )
        }
    }
    
    func tapToNextLocation(location: Location) {
        withAnimation{
            currentIndex = location.id - 1
            updateMapRegion(location: location)
      
        }
    }
    
    
    func swipeAction(){
        guard let currentIndex = locations.firstIndex(where: {$0 == mapLocation}) else { return }
        
        let nextIndex = currentIndex + 1
        
        guard locations.indices.contains(nextIndex) else {
            
            guard let firstLocation = locations.first else { return }
            tapToNextLocation(location: firstLocation)
            return
        }
    }
    
//    @Published var region =
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 41.6938, longitude: 44.8015),
//            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        )
//    
//    var locationManager: CLLocationManager?
//    
//    
//    
//    func checkIfLocationManagerEnabled() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager = CLLocationManager()
//            locationManager?.delegate = self
//            
//        } else {
//            print("it's off and please active")
//        }
//    }
//    
//    private  func checkLocationAuthorization(){
//        guard let locationManager = locationManager else { return }
//        
//        switch locationManager.authorizationStatus {
//            
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted:
//            print("you location is restricted likely due parental control")
//        case .denied:
//            print("you have denied please go to setting")
//        case .authorizedAlways, .authorizedWhenInUse:
//            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//        @unknown default:
//            break
//        }
//    }
//   
//       func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//           checkLocationAuthorization()
//       }
//       
       
}


