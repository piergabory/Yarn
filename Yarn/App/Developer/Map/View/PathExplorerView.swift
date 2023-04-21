//
//  PathExplorerView.swift
//  Yarn
//
//  Created by Pierre Gabory on 08/04/2023.
//

import LocationDatabase
import CoreLocation
import MapView
import MapKit
import SwiftUI

struct PathExplorerView: View {
    @Environment(\.managedObjectContext) var dbContext
    @StateObject var model = PathExplorer()
    @State var region = MKCoordinateRegion(.world)
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MKMapViewRepresentable(region: $region)
                .mapType(.mutedStandard)
                .mapOverlay(aboveRoads: model.overlays)
                #if os(iOS)
                .toolbarBackground(.visible, for: .automatic)
                .edgesIgnoringSafeArea(.all)
                #endif
            DateIntervalPicker(selection: $model.dateInterval)
                .padding()
                .background(.regularMaterial)
        }
        .onAppear {
            model.managedObjectContext = dbContext
        }
        .navigationTitle("Path Explorer")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct PathExplorerView_Previews: PreviewProvider {
    static var previews: some View {
        PathExplorerView()
    }
}
