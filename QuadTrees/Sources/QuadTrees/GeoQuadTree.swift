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
    // Child Nodes
    public var northEast: GeoQuadTree?
    public var northWest: GeoQuadTree?
    public var southEast: GeoQuadTree?
    public var southWest: GeoQuadTree?
    public var childNodes: [GeoQuadTree] {
        [northEast, northWest, southEast, southWest]
            .compactMap { $0 }
    }
    
    // Elements
    let capacity: Int
    
    public var elements: [Element] = []
    public let region: RectangularRegion
    public let level: Int
    public let geoHash: DecimalGeoHash
    public var count = 0
    
    public convenience init(capacity: Int = 10) {
        self.init(region: .world, level: 0, geoHash: DecimalGeoHash(), capacity: capacity)
    }
    
    init(region: RectangularRegion, level: Int, geoHash: DecimalGeoHash, capacity: Int) {
        self.region = region
        self.level = level
        self.geoHash = geoHash
        self.capacity = capacity
    }
}
