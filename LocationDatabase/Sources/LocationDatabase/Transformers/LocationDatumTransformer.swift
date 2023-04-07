//
//  LocationDatumConvertor.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
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
    public func convert(_ dbDatum: DBLocationDatum) -> LocationDatum {
        LocationDatum(
            latitude: dbDatum.latitude,
            longitude: dbDatum.longitude,
            date: dbDatum.date!
        )
    }
    
    public func update(_ dbDatum: DBLocationDatum, with datum: LocationDatum) {
        dbDatum.longitude = datum.longitude
        dbDatum.latitude = datum.latitude
        dbDatum.date = datum.date
    }
}
