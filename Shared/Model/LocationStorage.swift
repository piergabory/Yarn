//
//  LocationStorage.swift
//  Yarn
//
//  Created by Pierre Gabory on 15/12/2020.
//

import Foundation
import CoreData

struct LocationStorage {
    let managedObjectContext: NSManagedObjectContext
    var currentSource: Source!
    
    mutating func startImport(sourceFile: String) {
        managedObjectContext.performAndWait {
            currentSource = Source(context: managedObjectContext)
            currentSource.date = Date()
            currentSource.name = sourceFile
        }
    }
    
    func store(locations: [GoogleMapTimeline.Location]) {
        managedObjectContext.perform {
            let storedLocations = locations.insert(in: managedObjectContext)
            currentSource.locations?.addingObjects(from: storedLocations)
            storedLocations.forEach { $0.source = currentSource }
            save()
        }
    }
    
    private func save() {
        do { try managedObjectContext.save() } catch { print(error) }
    }
}
