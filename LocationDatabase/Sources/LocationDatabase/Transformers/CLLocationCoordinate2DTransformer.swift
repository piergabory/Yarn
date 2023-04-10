//
//  CLLocationCoordinate2DFetchRequest.swift
//  
//
//  Created by Pierre Gabory on 08/04/2023.
//

import Foundation
import CoreLocation

public typealias CLLocationCoordinate2DFetchRequest = FetchRequest<CLLocationCoordinate2DConvertor>
public extension CLLocationCoordinate2DFetchRequest {
    init() {
        self.init(convertor: CLLocationCoordinate2DConvertor())
        set(sortDescriptor: NSSortDescriptor(
            keyPath: \DBTimedCoordinates.date,
            ascending: true
        ))
    }
    
    func filter(dateInterval: DateInterval) -> Self{
        set(predicate: NSPredicate(
            format: "date > %@ AND date < %@",
            dateInterval.start as NSDate,
            dateInterval.end as NSDate
        ))
    }
}

public struct CLLocationCoordinate2DConvertor: DTOConvertor {
    public func convert(_ dbCoordinates: DBTimedCoordinates) throws -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: dbCoordinates.latitude,
            longitude: dbCoordinates.longitude
        )
    }
}
