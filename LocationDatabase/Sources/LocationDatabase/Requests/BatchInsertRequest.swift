//
//  BatchInsertRequest.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import CoreData
import Foundation

public struct BatchInsertRequest<Updator: DTOUpdator>: Request {
    let updator: Updator
    let batch: [Updator.DTO]
    
    public func execute(in context: NSManagedObjectContext) async throws -> Void {
        var dataIterator = batch.makeIterator()
        let entity = Updator.DBO.entity()

        let batchRequest = NSBatchInsertRequest(entity: entity) { (managedObject: NSManagedObject) in
            let dbObject = managedObject as? Updator.DBO
            let dto = dataIterator.next()
            if let dbObject, let dto {
                updator.update(dbObject, with: dto)
                return false
            } else {
                return true
            }
        }

        try await context.perform {
            try context.execute(batchRequest)
            try context.save()
        }
    }
}
