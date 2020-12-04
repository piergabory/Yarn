//
//  SidebarView.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI

struct SidebarView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var runningImports: [SourceImport] = []
    @State private var showFileBrowserModal = false
    
    var body: some View {
        List {
            SourceImportList($runningImports)
            SourceList()
        }
        .listStyle(SidebarListStyle())
        .toolbar { importButton }
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
                let sourceImport = try SourceImport(
                    filePath: filePath,
                    saveIn: managedObjectContext
                )
                runningImports.append(sourceImport)
            } catch {
                print(error)
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
