//
//  InsertRequest.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import CoreData
import Foundation

public struct InsertRequest<Updator: DTOUpdator>: Request {
    let updator: Updator
    let dto: Updator.DTO
    
    public func execute(in context: NSManagedObjectContext) async throws -> Void {
        try await context.perform {
            let dbObject = Updator.DBO(context: context)
            try updator.update(dbObject, with: dto)
            try context.save()
        }
    }
}
