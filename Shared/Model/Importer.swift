//
//  Importer.swift
//  Yarn
//
//  Created by Pierre Gabory on 15/12/2020.
//

import SwiftUI
import UniformTypeIdentifiers

class Importer: DropDelegate, ObservableObject {
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .copy)
    }
    
    func validateDrop(info: DropInfo) -> Bool {
        info.hasItemsConforming(to: [.json])
    }
    
    func performDrop(info: DropInfo) -> Bool {
        guard let provider = info.itemProviders(for: [.json]).first else { return false }
        provider.loadInPlaceFileRepresentation(forTypeIdentifier: UTType.json.identifier) { url, _, error in
            guard let url = url, error == nil else {
                print(error ?? "???")
                return
            }
            self.import(from: url)
        }
        return true
    }
    
    func `import`(from url: URL) {
        let coordinator = NSFileCoordinator(filePresenter: Import.filePresenter(for: url))
        coordinator.coordinate(readingItemAt: url, options: .withoutChanges, error: nil) { url in
            let task = Import(fileAt: url)
            DispatchQueue.main.async {
                self.importTask = task
            }
        }
    }
    
    @Published var importTask: Import? = nil
}
