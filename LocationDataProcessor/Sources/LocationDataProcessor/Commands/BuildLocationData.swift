//
//  BuildLocationData.swift
//  
//
//  Created by Pierre Gabory on 09/04/2023.
//

import Foundation
import Combine
import CoreData
import CoreLocation
import LocationDatabase
import DataTransferObjects

private enum Constants {
    static let earthRadius = 6_371_000.0 // meters
    static let fastDistanceComputeThreshold = 100_000.0 // 100 KM
    static let speedOfSound = 300.0 // m/s
}

struct BuildLocationData: DataProcessorCommand {
    
    let logStream = PassthroughSubject<String, Never>()

    func execute(dbContext: NSManagedObjectContext) async throws {
        let locationData = try await dbContext.perform {
            logStream.send("Build location data")
            let dbCoordinates = try fetchSortedTimedCoordinates(dbContext)
            return buildLocationData(from: dbCoordinates, dbContext: dbContext)
        }

        logStream.send("Saving \(locationData.count) datums.")
        try await BatchLocationDatumInsertRequest(data: locationData).execute(in: dbContext)
        logStream.send("Finished")
    }
    
    private func fetchSortedTimedCoordinates(_ dbContext: NSManagedObjectContext) throws -> [DBTimedCoordinates] {
        let filterRequest = NSFetchRequest<DBTimedCoordinates>()
        filterRequest.entity = DBTimedCoordinates.entity()
        filterRequest.sortDescriptors = [NSSortDescriptor(keyPath: \DBTimedCoordinates.date, ascending: true)]
        return try dbContext.fetch(filterRequest)
    }
    
    private func buildLocationData(from dbTimedCoordinates: [DBTimedCoordinates], dbContext: NSManagedObjectContext) -> [LocationDatum] {
        var previousPoint: DBTimedCoordinates?
        var locationData: [LocationDatum] = []
        for currentPoint in dbTimedCoordinates {
            defer { previousPoint = currentPoint }
            guard let previousPoint else { continue }
            
            let timeInterval = computeTimeInterval(between: previousPoint, and: currentPoint)
            let distance = computeDistance(between: previousPoint, and: currentPoint)
            let speed = distance / timeInterval
            
            guard let date = previousPoint.date else { continue }
            let datum = LocationDatum(
                latitude: previousPoint.latitude,
                longitude: previousPoint.longitude,
                date: date,
                duration: timeInterval,
                distance: distance,
                speed: abs(speed)
            )
            locationData.append(datum)
        }
        return locationData
    }
   
    // MARK: Compute Distance and Time
    
    private func computeTimeInterval(between currentCoordinates: DBTimedCoordinates, and nextCoordinates: DBTimedCoordinates) -> TimeInterval {
        if let currentDate = currentCoordinates.date, let nextDate = nextCoordinates.date {
            return currentDate.timeIntervalSince(nextDate)
        } else {
            return 0
        }
    }
    
    private func computeDistance(between currentCoordinates: DBTimedCoordinates, and nextCoordinates: DBTimedCoordinates) -> Double {
        // Fast distance compute
        let deltaLatitude = nextCoordinates.latitude - currentCoordinates.latitude
        let deltaLongitude = nextCoordinates.longitude - currentCoordinates.longitude
        var distance = sqrt(deltaLatitude * deltaLatitude + deltaLongitude * deltaLongitude) * Constants.earthRadius
        
        if distance > Constants.fastDistanceComputeThreshold {
            // Precise distance compute
            distance = clLocation(nextCoordinates).distance(from: clLocation(currentCoordinates))
        }
        return distance
    }

    private func clLocation(_ dbCoordinates: DBTimedCoordinates) -> CLLocation {
        CLLocation(latitude: dbCoordinates.latitude, longitude: dbCoordinates.longitude)
    }
}
