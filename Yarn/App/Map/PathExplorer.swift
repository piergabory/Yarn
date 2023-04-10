//
//  PathExplorer.swift
//  Yarn
//
//  Created by Pierre Gabory on 09/04/2023.
//

import CalendarTools
import CoreData
import Foundation
import LocationDatabase
import MapKit

@MainActor class PathExplorer: ObservableObject {
    
    var managedObjectContext: NSManagedObjectContext?
    
    @Published var overlays: [MKOverlay] = []
    
    @Published var dateInterval = DateInterval(start: .now.startOfDay, end: .now.endOfDay) {
        didSet { Task { try await buildPath() } }
    }

    func buildPath() async throws {
        guard let managedObjectContext else { return }
        let paths = try await GeoPathFetchRequest()
            .filter(dateInterval: dateInterval)
            .execute(in: managedObjectContext)
        
        var pathsOverlays: [MKPolyline] = []
        var connections: [MKPolyline] = []
        var lastPointOfPreviousPath: CLLocationCoordinate2D?
        for bounds in paths {
            let points = try await CLLocationCoordinate2DFetchRequest()
                .filter(dateInterval: DateInterval(start: bounds.startDate, end: bounds.endDate))
                .execute(in: managedObjectContext)
            if points.count > 2 {
                pathsOverlays.append(MKPolyline(coordinates: points, count: points.count))
            }
            if let lastPointOfPreviousPath, let firstPointOfCurrentPath = points.first {
                let line = [lastPointOfPreviousPath, firstPointOfCurrentPath]
                connections.append(MKPolyline(coordinates: line, count: line.count))
            }
            lastPointOfPreviousPath = points.last
        }

        let pathOverlay = MKMultiPolyline(pathsOverlays)
        pathOverlay.title = "Paths"
        
        let connectionsOverlay = MKMultiPolyline(connections)
        connectionsOverlay.title = "Connections"
        
        self.overlays = [pathOverlay, connectionsOverlay]
    }
}
