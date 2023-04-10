//
//  NullLocationFilter.swift
//  
//
//  Created by Pierre Gabory on 09/04/2023.
//

import Foundation
import CoreData
import LocationDatabase

struct NullLocationFilter: LocationDataProcessorCommand {
    
    func execute(dbContext: NSManagedObjectContext) async throws {
        let predicateQuery = "latitude < -0.01 AND latitude > 0.01 AND longitude < -0.01 AND longitude > 0.01"

        let result = try await dbContext.perform {
            print("Started clearing Null points")
            
            let filterRequest = NSFetchRequest<NSFetchRequestResult>()
            filterRequest.entity = DBTimedCoordinates.entity()
            filterRequest.predicate = NSPredicate(format: predicateQuery)
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: filterRequest)
            deleteRequest.resultType = .resultTypeCount
            
            let result = try dbContext.execute(deleteRequest)
            try dbContext.save()
            return result
        }

        if let deleteResult = result as? NSBatchDeleteResult, let count = deleteResult.result as? Int {
            print("Deleted \(count) items")
        }
    }
}
