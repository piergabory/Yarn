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
            PathExplorerView()
                .toolbar {
                    NavigationLink {
                        ProcessingView()
                            .navigationTitle("Data Processing")
                    } label: {
                        Label("Data Processing", systemImage: "trash.fill")
                    }
                    NavigationLink {
                        StatisticsView()
                            .navigationTitle("Statistics")
                    } label: {
                        Label("Statistics", systemImage: "chart.pie.fill")
                    }
                    NavigationLink {
                        FileImportView()
                            .navigationTitle("File Import")
                    } label: {
                        Label("Imports", systemImage: "square.and.arrow.down.on.square")
                    }
                }
        }
        .environment(\.managedObjectContext, locationDatabase.viewContext)
        .task {
            do {
                try await locationDatabase.loadPersistentStores()
            } catch {
                print("Error Loading Persistent Stores\n\(error)")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
