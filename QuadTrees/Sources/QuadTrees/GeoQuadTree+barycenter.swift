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
        var latitude = 0.0
        var longitude = 0.0
        for node in childNodes {
            let weight = Double(node.count)
            latitude += node.region.center.latitude * weight
            longitude += node.region.center.longitude * weight
        }
        let divider = Double(count)
        latitude /= divider
        longitude /= divider
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
