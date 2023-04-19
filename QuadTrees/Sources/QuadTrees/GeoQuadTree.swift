//
//  QuadTree.swift
//  
//
//  Created by Pierre Gabory on 14/04/2023.
//

import Foundation
import CoreLocation

public protocol Geolocatable {
    var geolocation: CLLocationCoordinate2D { get }
}

public class GeoQuadTree<Element: Geolocatable> {
    // Elements
    let capacity: Int
    var elements: [Element]
    
    // Child Nodes
    var northEast: GeoQuadTree?
    var northWest: GeoQuadTree?
    var southEast: GeoQuadTree?
    var southWest: GeoQuadTree?
    var childNodes: [GeoQuadTree] {
        [northEast, northWest, southEast, southWest]
            .compactMap { $0 }
    }
    
    public let region: RectangularRegion
    public let level: Int
    public let geoHash: DecimalGeoHash

    public var count = 0
    
    init(
        region: RectangularRegion = .world,
        level: Int = 0,
        geoHash: DecimalGeoHash = [],
        elements: [Element] = [],
        capacity: Int = 10
    ) {
        self.region = region
        self.level = level
        self.geoHash = geoHash
        self.capacity = capacity
        self.elements = elements
    }
}
