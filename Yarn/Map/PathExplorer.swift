//
//  PathExplorer.swift
//  Yarn
//
//  Created by Pierre Gabory on 09/04/2023.
//

import CalendarTools
import CoreData
import CoreLocation
import Foundation
import LocationDatabase

@MainActor class PathExplorer: ObservableObject {
    
    var managedObjectContext: NSManagedObjectContext?
    @Published var paths: [[CLLocationCoordinate2D]] = []
    @Published var dateInterval = DateInterval(start: .now.startOfDay, end: .now.endOfDay) {
        didSet { Task { try await buildPath() } }
    }

    func buildPath() async throws {
        guard let managedObjectContext else { return }
        let paths = try await GeoPathFetchRequest()
            .filter(dateInterval: dateInterval)
            .execute(in: managedObjectContext)
        
        var coordinatesSets: [[CLLocationCoordinate2D]] = []
        for bounds in paths {
            let coordinatesSet = try await CLLocationCoordinate2DFetchRequest()
//                .filterNullPoints()
                .filter(dateInterval: DateInterval(start: bounds.startDate, end: bounds.endDate))
                .execute(in: managedObjectContext)
            if coordinatesSet.count > 2 {
                coordinatesSets.append(coordinatesSet)
            }
        }
        self.paths = coordinatesSets
    }
}
