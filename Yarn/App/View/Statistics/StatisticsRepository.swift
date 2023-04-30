//
//  StatisticsRepository.swift
//  Yarn
//
//  Created by Pierre Gabory on 30/04/2023.
//

import CoreData
import Foundation
import LocationDatabase

final class StatisticsRepository: ObservableObject {
    
    struct MovementDataPoint: Identifiable {
        let date: Date
        let distance: Double
        
        var id: Date { date }
    }
    
    @Published var numberOfLocations: Int = 0
    @Published var maximumSpeed: Double?
    @Published var firstMeasurementDate: Date?
    @Published var lastMeasurementDate: Date?
    @Published var movementDataPoint: [MovementDataPoint] = []
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet { fetchData() }
    }
    
    private func fetchData() {
        guard let context = managedObjectContext else { return }
        
        let request = NSFetchRequest<DBLocationDatum>()
        request.entity = DBLocationDatum.entity()
        context.perform { [self] in
            do {
                numberOfLocations = try context.count(for: request)
                
                request.sortDescriptors = [NSSortDescriptor(keyPath: \DBLocationDatum.date, ascending: true)]
                let dateSortedResult = try context.fetch(request)
                firstMeasurementDate = dateSortedResult.first?.date
                lastMeasurementDate = dateSortedResult.last?.date
                movementDataPoint = dateSortedResult.suffix(100).compactMap { datum in
                    if let date = datum.date {
                        return MovementDataPoint(date: date, distance: datum.distance)
                    } else {
                        return nil
                    }
                }
                request.sortDescriptors = [NSSortDescriptor(keyPath: \DBLocationDatum.speed, ascending: true)]
                let speedSortedResults = try context.fetch(request)
                maximumSpeed = speedSortedResults.last?.speed
            } catch {
                print(error)
            }
        }
    }
}
