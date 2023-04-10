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
            MapView(paths: model.paths)
            DateIntervalPicker(selection: $model.dateInterval)
                .padding()
                .background(.regularMaterial)
        }
        .onAppear {
            model.managedObjectContext = dbContext
        }
        .navigationTitle("Path Explorer")
    }
}

struct PathExplorerView_Previews: PreviewProvider {
    static var previews: some View {
        PathExplorerView()
    }
}
