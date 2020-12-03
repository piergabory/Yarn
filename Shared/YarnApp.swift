//
//  YarnApp.swift
//  Shared
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI

@main
struct YarnApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
