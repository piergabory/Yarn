//
//  ContentView.swift
//  Shared
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var showFileImporter = false
    @StateObject private var importDropDelegate = Importer()
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MapView(path: [])
                .ignoresSafeArea()
            VStack {
                if let importTask = importDropDelegate.importTask {
                    ImportView(importTask: importTask)
                } else {
                    Button("Import File") { showFileImporter.toggle() }
                }
            }
            .frame(width: 300)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .padding()
        }
        .onDrop(of: [.json], delegate: importDropDelegate)
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.json], onCompletion: handle(fileImporter:))
    }
    
    private func handle(fileImporter result: Result<URL, Error>) {
        switch result {
        case let .failure(error):
            print(error)
        case let .success(url):
            importDropDelegate.import(from: url)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext,  PersistenceController.preview.container.viewContext)
            .previewLayout(.sizeThatFits)
    }
}
