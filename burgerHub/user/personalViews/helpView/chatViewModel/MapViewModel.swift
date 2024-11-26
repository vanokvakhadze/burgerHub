//
//  MapViewModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 21.11.24.
//

import SwiftUI
import MapKit



class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var cameraPosition: MapCameraPosition =  .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.6938, longitude: 44.8015),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    
   
    var locationManager: CLLocationManager?
    
    
    func checkIfLocationManagerEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
            
        } else {
            print("it's off and please active")
        }
    }
    
    private  func checkLocationAuthorization(){
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("you location is restricted likely due parental control")
        case .denied:
            print("you have denied please go to setting")
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = locationManager.location {
                            updateCameraPosition(for: location.coordinate)
                    }
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                updateCameraPosition(for: location.coordinate)
            }
        }

  func updateCameraPosition(for coordinate: CLLocationCoordinate2D) {
            DispatchQueue.main.async {
                self.cameraPosition = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            }
        }
}


