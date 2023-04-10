//
//  TimedCoordinatesConvertor.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import Foundation
import DataTransferObjects

public typealias TimedCoordinatesFetchRequest = FetchRequest<TimedCoordinatesTransformer>
public extension TimedCoordinatesFetchRequest {
    init() {
        self.init(convertor: TimedCoordinatesTransformer())
    }
}

public typealias BatchTimedCoordinatesInsertRequest = BatchInsertRequest<TimedCoordinatesTransformer>
public extension BatchTimedCoordinatesInsertRequest {
    init(data: [TimedCoordinates]) {
        self.init(updator: TimedCoordinatesTransformer(), batch: data)
    }
}

public struct TimedCoordinatesTransformer: DTOTransformer {
    public func convert(_ dbCoordinates: DBTimedCoordinates) -> TimedCoordinates {
        TimedCoordinates(
            latitude: dbCoordinates.latitude,
            longitude: dbCoordinates.longitude,
            date: dbCoordinates.date!
        )
    }
    
    public func update(_ dbCoordinates: DBTimedCoordinates, with coordinates: TimedCoordinates) {
        dbCoordinates.longitude = coordinates.longitude
        dbCoordinates.latitude = coordinates.latitude
        dbCoordinates.date = coordinates.date
    }
}
