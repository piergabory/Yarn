//
//  ImporterView.swift
//  Yarn
//
//  Created by Pierre Gabory on 15/12/2020.
//

import SwiftUI

struct ImporterView: View {
    @State private var showFileImporter = false
    @StateObject private var importDropDelegate = Importer()
    
    var body: some View {
        Group {
            if let importTask = importDropDelegate.importTask {
                ImportView(importTask: importTask)
            } else {
                Button("Import File") { showFileImporter.toggle() }
            }
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


struct ImporterView_Previews: PreviewProvider {
    static var previews: some View {
        ImporterView()
            .previewLayout(.sizeThatFits)
    }
}
