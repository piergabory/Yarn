//
//  RootView.swift
//  Yarn
//
//  Created by Pierre Gabory on 04/04/2023.
//

import SwiftUI
import LocationDatabase

struct RootView: View {
    
    let locationDatabase = LocationDatabase.main
    
    var body: some View {
        NavigationStack {
            FileImportView()
                .toolbar {
                    NavigationLink("Statistics") {
                        StatisticsView()
                    }
                }
        }
        .environment(\.managedObjectContext, locationDatabase.viewContext)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
