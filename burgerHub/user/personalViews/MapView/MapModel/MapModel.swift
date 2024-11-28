//
//  MapModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 21.11.24.
//

import Foundation
import MapKit



struct Location: Identifiable, Equatable {

    var id: Int
    var name: String
    var cityName: String
    var coordinates: CLLocationCoordinate2D
    var image: String
    
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
}



class MapLocation {
    static let location: [Location] = [
        Location(id: 1, name: "burger hub", cityName: "tbilisi vake", coordinates: CLLocationCoordinate2D(latitude: 41.711334, longitude: 44.75671), image: "burger"),
        Location(id: 2, name: "burger hub", cityName: "tbilisi gldani", coordinates: CLLocationCoordinate2D(latitude: 41.790901, longitude: 44.815322), image: "burger"),
        Location(id: 3, name: "burger hub", cityName: "tbilisi vaja", coordinates: CLLocationCoordinate2D(latitude: 41.728822, longitude: 44.738789), image: "burger"),
        Location(id: 4, name: "burger hub", cityName: "tbilisi varketili", coordinates: CLLocationCoordinate2D(latitude: 41.690206, longitude: 44.897533), image: "burger")
    ]
    
    
}
