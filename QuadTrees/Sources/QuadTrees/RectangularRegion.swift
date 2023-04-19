//
//  RectangularRegion.swift
//  
//
//  Created by Pierre Gabory on 14/04/2023.
//

import Foundation
import CoreLocation

public struct RectangularRegion {
    public let center: CLLocationCoordinate2D
    public let latitudeDelta: CLLocationDegrees
    public let longitudeDelta: CLLocationDegrees
    
    public var northEast: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: center.latitude + latitudeDelta,
            longitude: center.longitude + longitudeDelta
        )
    }
    
    public var southWest: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: center.latitude - latitudeDelta,
            longitude: center.longitude - longitudeDelta
        )
    }
    
    
    public init(center: CLLocationCoordinate2D, latitudeDelta: CLLocationDegrees, longitudeDelta: CLLocationDegrees) {
        self.center = center
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
    
    // MARK: - Default Regions
    
    public static let world = RectangularRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        latitudeDelta: 180,
        longitudeDelta: 360
    )
    
    // MARK: - Geometry
    
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let alignLongitude = abs(coordinate.longitude - center.longitude) < longitudeDelta
        let alignLatitude = abs(coordinate.latitude - center.latitude) < latitudeDelta
        return alignLongitude && alignLatitude
    }
    
    func intersect(region: RectangularRegion) -> Bool {
        let minLong = center.longitude - longitudeDelta / 2.0
        let minLat = center.latitude - latitudeDelta / 2.0
        let regionMinLong = region.center.longitude - region.longitudeDelta / 2.0
        let regionMinLat = region.center.latitude - region.latitudeDelta / 2.0
        
        let left = max(minLong, regionMinLong)
        let right = min(minLong + longitudeDelta, regionMinLong + region.longitudeDelta)
        let top = max(minLat, regionMinLat)
        let bottom = min(minLat + latitudeDelta, regionMinLat + region.latitudeDelta)
        
        return left < right && top < bottom
    }
    
    // MARK: - Quadrant subdivision
    
    struct Quadrant {
        let latitudeSign: Double
        let longitudeSign: Double
        
        static let northWest = Quadrant(latitudeSign: +1, longitudeSign: +1)
        static let northEast = Quadrant(latitudeSign: +1, longitudeSign: -1)
        static let southWest = Quadrant(latitudeSign: -1, longitudeSign: +1)
        static let southEast = Quadrant(latitudeSign: -1, longitudeSign: -1)
    }
    
    func subRegion(for quadrant: Quadrant) -> RectangularRegion {
        let halfLatitude = latitudeDelta / 2
        let halfLongitude = longitudeDelta / 2
        let center = CLLocationCoordinate2D(
            latitude: center.latitude + quadrant.latitudeSign * halfLatitude,
            longitude: center.longitude + quadrant.longitudeSign * halfLongitude
        )
        return RectangularRegion(
            center: center,
            latitudeDelta: halfLatitude,
            longitudeDelta: halfLongitude
        )
    }
}
