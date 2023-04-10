//
//  HighSpeedFilter.swift
//  
//
//  Created by Pierre Gabory on 09/04/2023.
//

import Foundation
import CoreData
import CoreLocation
import LocationDatabase

private enum Constants {
    static let earthRadius = 6_371_000.0 // meters
    static let fastDistanceComputeThreshold = 100_000.0 // 100 KM
    static let speedOfSound = 300.0 // m/s
}

struct HighSpeedFilter: LocationDataProcessorCommand {

    func execute(dbContext: NSManagedObjectContext) async throws {
        try await dbContext.perform {
            print("Started filtering movements over Mach 1")
            let dbLocationData = try fetchSortedLocationData(dbContext)
            let candidates = highSpeedMovementIds(with: dbLocationData)
            try delete(managedObjectIds: Array(candidates), using: dbContext)
            try dbContext.save()
        }
    }
    
    private func delete(managedObjectIds: [NSManagedObjectID], using dbContext: NSManagedObjectContext) throws {
        if managedObjectIds.isEmpty {
            print("Nothing to delete")
            return
        }

        let deleteRequest = NSBatchDeleteRequest(objectIDs: managedObjectIds)
        deleteRequest.resultType = .resultTypeCount
        let result = try dbContext.execute(deleteRequest)
        if let deleteResult = result as? NSBatchDeleteResult, let count = deleteResult.result as? Int {
            print("Deleted \(count) items")
        }
    }
    
    private func highSpeedMovementIds(with dbLocationData: [DBTimedCoordinates]) -> Set<NSManagedObjectID> {
        var skipped = Set<NSManagedObjectID>()
        var previous: DBTimedCoordinates?
        for current in dbLocationData {
            if skipped.contains(current.objectID) {
                continue
            }
            if let previous {
                let speed = computeSpeed(between: previous, and: current)
                if speed > Constants.speedOfSound {
                    skipped.insert(current.objectID)
                }
            }
            previous = current
        }
        return skipped
    }
    
    private func fetchSortedLocationData(_ dbContext: NSManagedObjectContext) throws -> [DBTimedCoordinates] {
        let filterRequest = NSFetchRequest<DBTimedCoordinates>()
        filterRequest.entity = DBTimedCoordinates.entity()
        filterRequest.sortDescriptors = [NSSortDescriptor(keyPath: \DBTimedCoordinates.date, ascending: true)]
        return try dbContext.fetch(filterRequest)
    }
    
    // MARK: Compute Speed
    
    private func computeSpeed(between currentCoordinates: DBTimedCoordinates, and nextCoordinates: DBTimedCoordinates) -> Double {
        guard let currentDate = currentCoordinates.date, let nextDate = nextCoordinates.date else { return 0 }
        let time = currentDate.timeIntervalSince(nextDate)
        
        var distance = fastDistanceCompute(between: currentCoordinates, and: nextCoordinates)
        if distance > Constants.fastDistanceComputeThreshold {
            distance = preciseDistanceCompute(between: currentCoordinates, and: nextCoordinates)
        }
        
        let speed = distance / time
        return abs(speed)
    }
    
    private func fastDistanceCompute(between currentCoordinates: DBTimedCoordinates, and nextCoordinates: DBTimedCoordinates) -> Double {
        let deltaLatitude = nextCoordinates.latitude - currentCoordinates.latitude
        let deltaLongitude = nextCoordinates.longitude - currentCoordinates.longitude
        return sqrt(deltaLatitude * deltaLatitude + deltaLongitude * deltaLongitude) * Constants.earthRadius
    }
    
    private func preciseDistanceCompute(between currentCoordinates: DBTimedCoordinates, and nextCoordinates: DBTimedCoordinates) -> Double {
        clLocation(nextCoordinates).distance(from: clLocation(currentCoordinates))
    }
            
    private func clLocation(_ dbCoordinates: DBTimedCoordinates) -> CLLocation {
        CLLocation(latitude: dbCoordinates.latitude, longitude: dbCoordinates.longitude)
    }
}
