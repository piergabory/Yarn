//
//  ContentView.swift
//  Shared
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var showFileBrowserModal = false
    @State private var runningImports: [SourceImport] = []
    
    var body: some View {
        NavigationView {
            List {
                SourceImportList($runningImports)
                SourceList()
            }
            .listStyle(SidebarListStyle())
            .toolbar { importButton }
            .navigationTitle("Yarn")
        }
        .fileImporter(
            isPresented: $showFileBrowserModal,
            allowedContentTypes: [.json],
            onCompletion: handleFileImporter
        )
    }
    
    private var importButton: some ToolbarContent {
        ToolbarItem {
            Button("Import data") { showFileBrowserModal.toggle() }
        }
    }
    
    private func handleFileImporter(result: Result<URL, Error>) {
        switch result {
        case let .failure(error):
            print(error)
        case let .success(filePath):
            do {
                let sourceImport = try SourceImport(filePath: filePath)
                runningImports.append(sourceImport)
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext,  PersistenceController.preview.container.viewContext)
    }
}
