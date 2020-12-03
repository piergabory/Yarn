//
//  Location + CLLocation.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import CoreLocation

extension Location {
    private var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        clLocation.coordinate
    }
    
    func distance(from target: Location) -> CLLocationDistance {
        clLocation.distance(from: target.clLocation)
    }
}
