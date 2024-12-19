//
//  MapModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 21.11.24.
//

import Foundation
import MapKit
import CoreLocation

struct Location: Identifiable, Equatable {

    var id: Int
    var name: String
    var cityName: String
    var coordinates: CLLocationCoordinate2D
    var image: String
    var adress: String
    var region: String?
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
   
    func distance(to location: CLLocation) -> CLLocationDistance {
            let currentLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            return currentLocation.distance(from: location)
        }
    
}





class MapLocation {
    static let location: [Location] = [
        Location(id: 0, name: "Burger hub", cityName: "Tbilisi", coordinates: CLLocationCoordinate2D(latitude: 41.711334, longitude: 44.75671), image: "burger1", adress: "Ilia Chavchavadze, 37" , region: "Vake"),
        Location(id: 1, name: "Burger hub", cityName: "Tbilisi", coordinates: CLLocationCoordinate2D(latitude: 41.790901, longitude: 44.815322), image: "burger2", adress: "Ilia Vekua, 3", region: "Gldani"),
        Location(id: 2, name: "Burger hub", cityName: "Tbilisi", coordinates: CLLocationCoordinate2D(latitude: 41.728822, longitude: 44.738789), image: "burger3", adress: "Vaja Pshavela, 22", region: "Saburtalo"),
        Location(id: 3, name: "Burger hub", cityName: "Tbilisi", coordinates: CLLocationCoordinate2D(latitude: 41.690206, longitude: 44.897533), image: "burger4", adress: "Aleksandre Tvalchrelidze , 2", region: "Varketili")
    ]
    
    
}
