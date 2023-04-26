//
//  ImportSourcesRepository.swift
//  Yarn
//
//  Created by Pierre Gabory on 27/04/2023.
//

import Combine
import CoreData
import DataTransferObjects
import Foundation
import LocationDatabase

class ImportSourcesRepository: ObservableObject {
    private var sourcePublisher: ImportSourcesPublisher?
    @Published var sources: [ImportSource] = []
    var cancellable: AnyCancellable?

    func set(context: NSManagedObjectContext) {
        let publisher = ImportSourcesPublisher(managedObjectContext: context)
        sourcePublisher = publisher
        cancellable = publisher.replaceError(with: []).sink { sources in
            self.sources = sources
        }
        
    }
}
