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
    @Published var path: [CLLocationCoordinate2D] = []
    @Published var dateInterval = DateInterval(start: .now.startOfDay, end: .now.endOfDay) {
        didSet { Task { try await buildPath() } }
    }

    func buildPath() async throws {
        guard let managedObjectContext else { return }
        print("Loading \(dateInterval)")
        let results = try await CLLocationCoordinate2DFetchRequest()
            .filter(dateInterval: dateInterval)
            .execute(in: managedObjectContext)
        print("Found \(results.count)")
        self.path = results
    }
}
