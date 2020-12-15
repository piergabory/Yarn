//
//  Import.swift
//  Yarn
//
//  Created by Pierre Gabory on 15/12/2020.
//

import Foundation
import Combine
import CoreData

class Import: ObservableObject {
    
    private let processingQueue = DispatchQueue(label: "Location processing")
    private var cancellables: Set<AnyCancellable> = []
    
    private var locationStorage: LocationStorage!
    private var stream: InputStream!
    
    private(set) var progress: Progress!
    
    let fileName: String
    
    init(fileAt path: URL) {
        fileName = path.lastPathComponent
        let fileSize = readImportedFileSizeAttribute(atPath: path)
        progress = Progress(totalUnitCount: fileSize)
        stream = InputStream(url: path)
        stream.open()
    }
    
    func store(managedObjectContext: NSManagedObjectContext) {
        locationStorage = LocationStorage(managedObjectContext: managedObjectContext)
        decode(stream: stream)
    }
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
    }
    
    private func decode(stream: InputStream) {
        let decodingTask = JSONStreamDecodingTask<GoogleMapTimeline.Location>(stream: stream)
        decodingTask.execute()
            .collect(1000)
            .receive(on: processingQueue)
            .sink(receiveCompletion: handle(completion:), receiveValue: handle(value:))
            .store(in: &cancellables)
        decodingTask.$progress
            .throttle(for: .milliseconds(300), scheduler: RunLoop.main, latest: true)
            .map(Int64.init)
            .handleEvents(receiveOutput: { _ in self.objectWillChange.send() })
            .assign(to: \Progress.completedUnitCount, on: progress)
            .store(in: &cancellables)
    }
    
    private func handle(completion: Subscribers.Completion<Error>) {
        print(completion)
        stream.close()
    }
    
    private func handle(value: [GoogleMapTimeline.Location]) {
        locationStorage.store(locations: value)
    }
    
    private func readImportedFileSizeAttribute(atPath url: URL) -> Int64 {
        guard
            let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
            let size = attributes[.size] as? NSNumber else {
            return 0
        }
        return size.int64Value
    }
}
