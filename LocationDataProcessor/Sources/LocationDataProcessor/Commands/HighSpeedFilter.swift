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
    
    private func highSpeedMovementIds(with dbLocationData: [DBLocationDatum]) -> Set<NSManagedObjectID> {
        var skipped = Set<NSManagedObjectID>()
        var previous: DBLocationDatum?
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
    
    private func fetchSortedLocationData(_ dbContext: NSManagedObjectContext) throws -> [DBLocationDatum] {
        let filterRequest = NSFetchRequest<DBLocationDatum>()
        filterRequest.entity = DBLocationDatum.entity()
        filterRequest.sortDescriptors = [NSSortDescriptor(keyPath: \DBLocationDatum.date, ascending: true)]
        return try dbContext.fetch(filterRequest)
    }
    
    // MARK: Compute Speed
    
    private func computeSpeed(between currentDatum: DBLocationDatum, and nextDatum: DBLocationDatum) -> Double {
        guard let currentDate = currentDatum.date, let nextDate = nextDatum.date else { return 0 }
        let time = currentDate.timeIntervalSince(nextDate)
        
        var distance = fastDistanceCompute(between: currentDatum, and: nextDatum)
        if distance > Constants.fastDistanceComputeThreshold {
            distance = preciseDistanceCompute(between: currentDatum, and: nextDatum)
        }
        
        let speed = distance / time
        return abs(speed)
    }
    
    private func fastDistanceCompute(between currentDatum: DBLocationDatum, and nextDatum: DBLocationDatum) -> Double {
        let deltaLatitude = nextDatum.latitude - currentDatum.latitude
        let deltaLongitude = nextDatum.longitude - currentDatum.longitude
        return sqrt(deltaLatitude * deltaLatitude + deltaLongitude * deltaLongitude) * Constants.earthRadius
    }
    
    private func preciseDistanceCompute(between currentDatum: DBLocationDatum, and nextDatum: DBLocationDatum) -> Double {
        clLocation(nextDatum).distance(from: clLocation(currentDatum))
    }
            
    private func clLocation(_ dbDatum: DBLocationDatum) -> CLLocation {
        CLLocation(latitude: dbDatum.latitude, longitude: dbDatum.longitude)
    }
}
