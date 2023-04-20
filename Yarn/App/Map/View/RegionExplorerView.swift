//
//  RegionExplorerView.swift
//  Yarn
//
//  Created by Pierre Gabory on 20/04/2023.
//

import LocationDatabase
import MapKit
import SwiftUI
import CoreData

@MainActor
final class RegionExplorer: ObservableObject {
    var dbContext: NSManagedObjectContext? = nil
    
    @Published var visibleArea = MKCoordinateRegion(.world) {
        didSet { Task { await refreshRegions() } }
    }
    
    @Published var regions: [DBGeoRegion] = []
    
    private func refreshRegions() async {
        let request = NSFetchRequest<DBGeoRegion>()
        request.entity = DBGeoRegion.entity()
        
        let zoom = (visibleArea.span.longitudeDelta) / 360
        let level = Int(abs(log2(zoom))) + 5
        
        request.predicate = NSPredicate(format: "level == \(level) AND count > 0")
        
        if let regions = try? dbContext?.fetch(request) {
            self.regions = regions
        }
    }
}

extension DBGeoRegion {
    var baryCenter: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: barycenterLatitude, longitude: barycenterLongitude)
    }
}

struct RegionExplorerView: View {
    @Environment(\.managedObjectContext) var dbContext
    @StateObject var regionExplorer = RegionExplorer()
    
    var body: some View {
        Map(
            coordinateRegion: $regionExplorer.visibleArea,
            annotationItems: regionExplorer.regions
        ) { region in
            MapAnnotation(coordinate: region.baryCenter) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.orange.opacity(0.2), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: log(CGFloat(region.count)) * 10
                            )
                        )
                        .frame(width: 1000)
                    Text(region.count, format: .number)
                        .font(.caption)
                        .background(.black)
                        
                }
            }
        }
        .onAppear {
            regionExplorer.dbContext = dbContext
        }
    }
    
}

struct RegionExplorerView_Previews: PreviewProvider {
    static var previews: some View {
        RegionExplorerView()
    }
}
