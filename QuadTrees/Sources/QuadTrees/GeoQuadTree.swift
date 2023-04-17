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
    public var count = 0
    
    init(region: RectangularRegion = .world, elements: [Element] = [], capacity: Int = 10) {
        self.region = region
        self.capacity = capacity
        self.elements = elements
    }
}
