//
//  PathExplorerView.swift
//  Yarn
//
//  Created by Pierre Gabory on 08/04/2023.
//

import LocationDatabase
import CoreLocation
import MapView
import SwiftUI

struct PathExplorerView: View {
    @Environment(\.managedObjectContext) var dbContext
    @StateObject var model = PathExplorer()
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MapView()
                .mapType(.mutedStandard)
                .overlays(model.overlays, level: .aboveRoads)
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
