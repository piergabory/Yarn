//
//  File.swift
//  
//
//  Created by Pierre Gabory on 18/04/2023.
//

import Foundation
import CoreLocation

extension GeoQuadTree {
    public var baryCenter: CLLocationCoordinate2D {
        let latitudeAverage = childNodes
            .map(\.region.center.latitude)
            .reduce(0, +) / Double(count)
        let longitudeAverage = childNodes
            .map(\.region.center.longitude)
            .reduce(0, +) / Double(count)
        return CLLocationCoordinate2D(latitude: latitudeAverage, longitude: longitudeAverage)
    }
}
