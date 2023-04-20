//
//  GeoQuadTreeUpdator.swift
//  
//
//  Created by Pierre Gabory on 20/04/2023.
//

import CoreData
import QuadTrees
import DataTransferObjects
import CoreLocation
import Foundation

public typealias GeoDataTree = GeoQuadTree<LocationDatum>

extension LocationDatum: Geolocatable {
    public var geolocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

public typealias BatchGeoRegionInsertRequest = BatchInsertRequest<GeoQuadTreeUpdator>
public extension BatchGeoRegionInsertRequest {
    init(regions: [GeoDataTree]) {
        self.init(updator: GeoQuadTreeUpdator(), batch: regions)
    }
}

public struct GeoQuadTreeUpdator: DTOUpdator {
    
    public func update(_ dbGeoRegion: DBGeoRegion, with region: GeoDataTree) throws {
        dbGeoRegion.latitudeMax = region.region.northEast.latitude
        dbGeoRegion.latitudeMin = region.region.southWest.latitude
        dbGeoRegion.longitudeMax = region.region.northEast.longitude
        dbGeoRegion.longitudeMin = region.region.southWest.longitude
        dbGeoRegion.barycenterLatitude = region.baryCenter.latitude
        dbGeoRegion.barycenterLongitude = region.baryCenter.longitude
        dbGeoRegion.count = Int64(region.count)
        dbGeoRegion.level = Int64(region.level)
        dbGeoRegion.geohash = region.geoHash.stringGeoHash
    }
}

