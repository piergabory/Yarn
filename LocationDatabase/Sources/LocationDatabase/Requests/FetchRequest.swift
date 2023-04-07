//
//  FetchRequest.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import CoreData
import Foundation

public struct FetchRequest<Convertor: DTOConvertor>: Request {
    let convertor: Convertor
    let request = NSFetchRequest<Convertor.DBO>()
    
    public func execute(in context: NSManagedObjectContext) async throws -> [Convertor.DTO] {
        try await context.perform {
            try context
                .fetch(request)
                .map(convertor.convert)
        }
    }
}
