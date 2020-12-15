//
//  SourceImport.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import Combine
import CoreData
import Foundation

class SourceImport: ObservableObject, Identifiable {
    
    private let decodingQueue = DispatchQueue(label: "Import Location Decoding")
    private let processingQueue = DispatchQueue(label: "Import Location Processing")
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var fileByteSize = 0
    private lazy var source = createSource()
    
    private let managedObjectContext: NSManagedObjectContext
    
    @Published private var readBytes = 0
    @Published private(set) var foundLocations = 0
    
    let filePath: URL
    
    var progress: Double { Double(readBytes) / Double(fileByteSize) }
    var fileName: String { filePath.lastPathComponent }
    
    init(filePath: URL, saveIn managedObjectContext: NSManagedObjectContext) throws {
        self.filePath = filePath
        self.managedObjectContext = managedObjectContext
        
        let coordinator = NSFileCoordinator(filePresenter: filePresenter)
        coordinator.coordinate(readingItemAt: filePath, options: .withoutChanges, error: nil) { url in
            fileByteSize = readSourceFileSize()
            guard let stream = InputStream(url: url) else { return }
            decodingQueue.async { [weak self] in
                self?.decode(stream: stream)
            }
        }
    }
    
    func cancel() {
        cancellableSet.forEach { $0.cancel() }
    }
    
    // MARK: - Private
    
    private func decode(stream: InputStream) {
        stream.open()
        let decodingTask = JSONStreamDecodingTask<GoogleMapTimeline.Location>(stream: stream)
        
        decodingTask.execute()
            .collect(.byTime(processingQueue, .milliseconds(500)))
            .map { [managedObjectContext] in $0.insert(in: managedObjectContext) }
            .sink(receiveCompletion: handle(completion:), receiveValue: handle(batch:))
            .store(in: &cancellableSet)
        
        decodingTask.$progress
            .throttle(for: .milliseconds(30), scheduler: RunLoop.main, latest: true)
            .assign(to: \.readBytes, on: self)
            .store(in: &cancellableSet)
    }
    
    private func handle(completion: Subscribers.Completion<Error>) {
        print(completion)
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    private func handle(batch locations: [Location]) {
        source.locations?.addingObjects(from: locations)
        DispatchQueue.main.async {
            self.foundLocations += locations.count
        }
    }
    
    private func createSource() -> Source {
        let source = Source(context: managedObjectContext)
        source.name = filePath.lastPathComponent
        source.date = Date()
        return source
    }
    
    private func readSourceFileSize() -> Int {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: filePath.path)
            return attributes[.size] as! Int
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    // MARK: - Preview
    
    private init() {
        managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        filePath = URL(fileURLWithPath: "/null/previewFile.json")
    }
    
    static let preview = SourceImport()
}
