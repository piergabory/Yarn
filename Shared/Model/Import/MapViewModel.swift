//
//  MapViewModel.swift
//  Yarn
//
//  Created by Pierre Gabory on 16/12/2020.
//

import Foundation
import CoreLocation
import CoreData

class MapViewModel: ObservableObject {
    
    // Input
    @Published var startDate = Calendar.current.date(byAdding: DateComponents(year: -1), to: Date())!
    @Published var endDate = Date()
    
    // Output
    var startDateRange: PartialRangeThrough<Date> { ...endDate }
    var endDateRange: PartialRangeFrom<Date> { startDate... }
    
    @Published var coordinates: [CLLocationCoordinate2D] = []
    
    private var fetchRequest: NSFetchRequest<Location> {
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)]
        request.predicate = NSPredicate(
            format: "timestamp > %@ AND timestamp < %@",
            startDate as NSDate,
            endDate as NSDate
        )
        return request
    }
    
    // Intent
    func updateMap(withDataFrom managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.perform { [self] in
            do {
                let results = try managedObjectContext.fetch(fetchRequest) as [Location]
                coordinates = results.map(\.coordinate)
            } catch {
                print(error)
            }
        }
    }
}
