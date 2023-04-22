//
//  DataManagementView.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI

enum PresentableScreens: String, Identifiable {
    case settings, fileImport
    
    var id: String { rawValue }
}

struct DataManagementView: View {
    
    @State var presentedScreen: PresentableScreens?
    
    var body: some View {
        NavigationStack() {
            List {
                ActivityProgressSection()
                StatisticsSection()
                ImportSourcesSections()
            }
                .navigationTitle("My Locations")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    DataManagementToolbarView(
                        presentedScreen: $presentedScreen
                    )
                }
        }
        .sheet(item: $presentedScreen) { screen in
            switch screen {
            case .settings:
                SettingsView { presentedScreen = nil }
            case .fileImport:
                FileImportView { presentedScreen = nil }
            }
        }
    }
}

struct DataManagementToolbarView: View {
    @Binding var presentedScreen: PresentableScreens?
    
    var body: some View {
        Group {
            Button { presentedScreen = .fileImport } label: {
                Label("Import Data", systemImage: "square.and.arrow.down")
            }
            Button { presentedScreen = .settings } label: {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

struct DataManagementView_Previews: PreviewProvider {
    static var previews: some View {
        Rectangle()
            .ignoresSafeArea(.all)
            .sheet(isPresented: .constant(true)) {
                DataManagementView()
            }
        
    }
}