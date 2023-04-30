//
//  RootView.swift
//  Yarn
//
//  Created by Pierre Gabory on 21/04/2023.
//

import SwiftUI
import LocationDatabase

struct RootView: View {
    private let dataBase = try! LocationDatabase()
    
    @State
    var isDataManagementViewVisible = true
    
    @State
    var canDismissDataManagementView = false
    
    @State
    var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        GeographicDataView(hideControls: $isDataManagementViewVisible)
            .sheet(isPresented: $isDataManagementViewVisible) {
                DataManagementView()
                    .scrollContentBackground(.hidden)
                    .presentationBackground(.thickMaterial)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large, .medium, .height(48)], selection: $selectedDetent)
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled(!canDismissDataManagementView)
            }
            .task {
                try? await dataBase.loadPersistentStores()
            }
            .environment(\.managedObjectContext, dataBase.viewContext)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
//            .preferredColorScheme(.dark)
    }
}
