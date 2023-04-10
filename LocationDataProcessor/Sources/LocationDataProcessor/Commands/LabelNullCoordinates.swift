//
//  LabelNullCoordinates.swift
//  
//
//  Created by Pierre Gabory on 09/04/2023.
//

import Foundation
import Combine
import CoreData
import LocationDatabase

struct LabelNullCoordinates: DataProcessorCommand {
    
    let logStream = PassthroughSubject<String, Never>()
    
    func execute(dbContext: NSManagedObjectContext) async throws {
        try await dbContext.perform {
            logStream.send("Started labelling Null points")
            
            let predicateFormat = "latitude < -0.01 AND latitude > 0.01 AND longitude < -0.01 AND longitude > 0.01"
            let labelRequest = DBTimedCoordinates.makeBatchUpdateRequest(label: .nullCoordinate)
            labelRequest.predicate = NSPredicate(format: predicateFormat)
            labelRequest.resultType = .updatedObjectsCountResultType
            
            let update = try dbContext.execute(labelRequest) as? NSBatchUpdateResult
            if let count = update?.result as? Int {
                logStream.send("Deleted \(count) items")
            }
            
            try dbContext.save()
            logStream.send("Finished")
        }
    }
}
