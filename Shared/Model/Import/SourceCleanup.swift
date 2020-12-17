//
//  LocationFilter.swift
//  Yarn
//
//  Created by Pierre Gabory on 17/12/2020.
//

import Foundation
import CoreData

struct SourceCleanup {
    let managedObjectContext: NSManagedObjectContext
    let source: Source
    
    func cleanSource() {
        let locations = source.sortedLocations
        var invalidated: Set<Location> = []
        for index in locations.indices[1...] {
            let current = locations[index]
            guard
                current.latitude != 0 && current.longitude != 0,
                current.timestamp?.timeIntervalSince1970 != 0 else {
                    invalidated.insert(current)
                    continue
            }
            let previous = locations[index - 1]
            guard
                previous.time(from: current) > 0, // discard teleportation
                previous.distance(from: current) > 0, // discard no movement
                previous.velocity(to: current) > 300 else { // discard faster than sound, probably a fluke
                    invalidated.insert(current)
                    continue
            }
        }
        managedObjectContext.perform {
            source.removeFromLocations(invalidated as NSSet)
        }
    }
}
