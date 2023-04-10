//
//  File.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import CalendarTools
import Combine
import CoreData
import DataTransferObjects
import Foundation
import LocationDatabase

private enum Constants {
    static let discontinuationTime = 6.hours
    static let overspeed = 300 // speed of sound in M/S
}

struct BuildPaths: DataProcessorCommand {
    let logStream = PassthroughSubject<String, Never>()
    
    func execute(dbContext: NSManagedObjectContext) async throws {
        logStream.send("Start building paths")
        let paths = try await dbContext.perform {
            let edges = try fetchPathEdges(dbContext)
            return buildPaths(from: edges)
        }
        logStream.send("Saving \(paths.count) paths")
        try await BatchGeoPathInsertRequest(paths: paths)
            .execute(in: dbContext)
        logStream.send("End building paths")
    }
    
    private func buildPaths(from pathEdges: [DBLocationDatum]) -> [GeoPath] {
        var paths: [GeoPath] = []
        var startDatum: DBLocationDatum?
        for endDatum in pathEdges {
            if let start = startDatum?.date, let end = endDatum.date {
                paths.append(GeoPath(startDate: start, endDate: end))
            }
            startDatum = endDatum
        }
        return paths
    }
    
    private func fetchPathEdges(_ dbContext: NSManagedObjectContext) throws -> [DBLocationDatum] {
        let fetchRequest = NSFetchRequest<DBLocationDatum>()
        fetchRequest.entity = DBLocationDatum.entity()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \DBLocationDatum.date, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "duration > \(Constants.discontinuationTime) OR speed > \(Constants.overspeed)")
        return try dbContext.fetch(fetchRequest)
    }
}
