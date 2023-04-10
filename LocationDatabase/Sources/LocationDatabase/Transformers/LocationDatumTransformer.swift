//
//  LocationDatumTransformer.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import Foundation
import DataTransferObjects


public typealias LocationDatumFetchRequest = FetchRequest<LocationDatumTransformer>
public extension LocationDatumFetchRequest {
    init() {
        self.init(convertor: LocationDatumTransformer())
    }
}

public typealias BatchLocationDatumInsertRequest = BatchInsertRequest<LocationDatumTransformer>
public extension BatchLocationDatumInsertRequest {
    init(data: [LocationDatum]) {
        self.init(updator: LocationDatumTransformer(), batch: data)
    }
}

public struct LocationDatumTransformer: DTOTransformer {
    public func convert(_ dbDatum: DBLocationDatum) throws -> LocationDatum {
        guard
            let date = dbDatum.date
        else { throw DTOConvertorError.invalidDatabaseObject(dbDatum) }
        return LocationDatum(
            latitude: dbDatum.latitude,
            longitude: dbDatum.longitude,
            date: date,
            duration: dbDatum.duration,
            distance: dbDatum.distance,
            speed: dbDatum.speed
        )
    }
    
    public func update(_ dbDatum: DBLocationDatum, with datum: LocationDatum) {
        dbDatum.longitude = datum.longitude
        dbDatum.latitude = datum.latitude
        dbDatum.date = datum.date
        dbDatum.duration = datum.duration
        dbDatum.distance = datum.distance
        dbDatum.speed = datum.speed
    }
}
