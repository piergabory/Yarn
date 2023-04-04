//
//  File.swift
//  
//
//  Created by Pierre Gabory on 28/03/2023.
//

import Foundation
import CoreData
import DataTransferObjects

// Base request types

public protocol Request {
    associatedtype ResultType
    func execute(in context: NSManagedObjectContext) async throws -> ResultType
}

struct FetchLocationDatumRequest: Request {
    private let request = NSFetchRequest<DBLocationDatum>()
    
    func execute(in context: NSManagedObjectContext) async throws -> [LocationDatum] {
        try await context.perform {
            try context
                .fetch(request)
                .map {
                    LocationDatum(
                        latitude: $0.latitude,
                        longitude: $0.longitude,
                        date: $0.date!
                    )
                }
        }
    }
}

struct InsertLocationDatumRequest: Request {
    let datum: LocationDatum
    
    func execute(in context: NSManagedObjectContext) async throws -> Void {
        try await context.perform {
            let dbDatum = DBLocationDatum(context: context)
            dbDatum.longitude = datum.longitude
            dbDatum.latitude = datum.latitude
            dbDatum.date = datum.date
            try context.save()
        }
    }
}

public struct BatchInsertLocationDataRequest: Request {
    let data: [LocationDatum]
    
    public init(data: [LocationDatum]) {
        self.data = data
    }
    
    public func execute(in context: NSManagedObjectContext) async throws -> Void {
        var dataIterator = data.makeIterator()
        let entity = DBLocationDatum.entity()

        let batchRequest = NSBatchInsertRequest(entity: entity) { (managedObject: NSManagedObject) in
            guard
                let dbDatum = managedObject as? DBLocationDatum,
                let datum = dataIterator.next()
            else { return true}

            dbDatum.longitude = datum.longitude
            dbDatum.latitude = datum.latitude
            dbDatum.date = datum.date
            return false
        }

        try await context.perform {
            try context.execute(batchRequest)
            try context.save()
        }
    }
}
