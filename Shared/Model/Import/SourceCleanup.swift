//
//  LocationFilter.swift
//  Yarn
//
//  Created by Pierre Gabory on 17/12/2020.
//

import Foundation
import CoreData
import Combine

struct SourceCleanup {
    private static let processingQueue = DispatchQueue(label: "LocationCleanup")
    
    let managedObjectContext: NSManagedObjectContext
    let source: Source
    var totalLocationCount: Int { source.locations?.count ?? 0 }
    let locationsProcessedCount = CurrentValueSubject<Int, Never>(0)

    func cleanSource() {
        SourceCleanup.processingQueue
            .async(execute: task)
    }
    
    // Parse through the source in order
    // remove null coordinates, null timestamps
    // remove teleporting, no movements
    // remove faster than sound movement, as its unlikely the user
    // maintains internet access while flying a fighter jet
    private func task() {
        let locations = source.sortedLocations
        var invalidated: Set<Location> = []
    
        print("Start \(source.name ?? "") cleanup")
        for index in locations.indices[1...] {
            let current = locations[index]
            guard
                abs(current.latitude) > 0.001 && abs(current.longitude) > 0.001 else {
                    invalidated.insert(current)
                    continue
            }
            
            let previous = locations[index - 1]
            guard
                previous.time(from: current) > 0,
                previous.distance(from: current) > 0,
                previous.velocity(to: current) < 300 else {
                    invalidated.insert(current)
                    continue
            }
            
            locationsProcessedCount.value = index
        }
        print("Saving  \(source.name ?? "") cleanup")
        print("remove \(invalidated.count) out of \(totalLocationCount)")
        
        managedObjectContext.perform {
            invalidated.forEach(managedObjectContext.delete)
            source.removeFromLocations(invalidated as NSSet)
            do { try managedObjectContext.save() } catch { print(error) }
            print("Finished  \(source.name ?? "") cleanup")
        }
    }
}
