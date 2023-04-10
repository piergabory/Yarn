//
//  GeoPathTransformer.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import CoreData
import DataTransferObjects
import Foundation

public typealias GeoPathFetchRequest = FetchRequest<GeoPathTransformer>
public extension GeoPathFetchRequest {
    init() {
        self.init(convertor: GeoPathTransformer())
    }
    
    func filter(dateInterval: DateInterval) -> Self{
        set(predicate: NSPredicate(
            format: "endDate > %@ AND startDate < %@",
            dateInterval.start as NSDate,
            dateInterval.end as NSDate
        ))
    }
}

public typealias BatchGeoPathInsertRequest = BatchInsertRequest<GeoPathTransformer>
public extension BatchGeoPathInsertRequest {
    init(paths: [GeoPath]) {
        self.init(updator: GeoPathTransformer(), batch: paths)
    }
}

public struct GeoPathTransformer: DTOTransformer {
    
    public func convert(_ dbPath: DBPath) throws -> GeoPath {
        if let start = dbPath.startDate, let end = dbPath.endDate {
            return GeoPath(startDate: start, endDate: end)
        } else {
            throw DTOConvertorError.invalidDatabaseObject(dbPath)
        }
    }
    
    public func update(_ dbPath: DBPath, with path: GeoPath) throws {
        dbPath.startDate = path.startDate
        dbPath.endDate = path.endDate
    }
}

