//
//  GoogleMapTimeline + Location.swift
//  Yarn
//
//  Created by Pierre Gabory on 04/12/2020.
//

import Foundation
import CoreData

extension GoogleMapTimeline.Location {
    
    func insert(in managedObjectContext: NSManagedObjectContext) -> Location {
        let store = Location(context: managedObjectContext)
        store.latitude = latitude
        store.longitude = longitude
        store.timestamp = date
        return store
    }
}

extension Collection where Element == GoogleMapTimeline.Location {
    
    func insert(in managedObjectContext: NSManagedObjectContext) -> [Location] {
        var locations: [Location]!
        managedObjectContext.performAndWait {
            locations = map { $0.insert(in: managedObjectContext) }
        }
        return locations
    }
}
