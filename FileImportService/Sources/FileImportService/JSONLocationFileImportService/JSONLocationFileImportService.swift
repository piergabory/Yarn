import Foundation
import LocationDatabase
import DataTransferObjects

private enum Constants {
    static let batchSize: Int64 = 200
    static let estimatedDatumByteSize: Int64 = 400
}

public struct JSONLocationFileImportService<Deserializer: JSONObjectDeserializer> where Deserializer.Item == LocationDatum {
    
    enum ImportError: Error {
        case failedToOpenFile
        case unexpectedFileAttributeType
    }

    private let importSource: ImportSource
    private let fileStream: InputStream
    private let fileDeserializer: JSONStreamDeserializer<Deserializer>
    private let fileStreamProgress: Progress?
    private let database: LocationDatabase
    
    public let progress = Progress(totalUnitCount: 100)
    
    public init(fileURL: URL, fileDeserializer: JSONStreamDeserializer<Deserializer>, database: LocationDatabase = .main) throws {
        importSource = ImportSource(fileURL: fileURL, importDate: .now)
        guard let fileStream = InputStream(url: fileURL) else { throw ImportError.failedToOpenFile }
        
        self.fileStream = fileStream
        self.fileDeserializer = fileDeserializer
        self.database = database
        
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            guard let fileSize = fileAttributes[.size] as? NSNumber else { throw ImportError.unexpectedFileAttributeType }
            fileStreamProgress = Progress(totalUnitCount: fileSize.int64Value)
        } catch {
            print("Failed to get information on imported file \(fileURL.lastPathComponent).\n" + error.localizedDescription)
            fileStreamProgress = nil
        }
    }

    public func load() async throws {
        let dataStream = try await deserializeFile()
        try await saveOutput(of: dataStream)
        try await logImportSource()
    }
    
    // MARK: - Private
    
    private func deserializeFile() async throws -> AsyncStream<LocationDatum> {
        let progressPolling =  Timer(timeInterval: 0.3, repeats: true) { _ in
            queryFileStreamProgress()
        }
        if let fileStreamProgress {
            progress.addChild(fileStreamProgress, withPendingUnitCount: 40)
        }
        
        print("Open filestream.")
        progressPolling.fire()
        fileStream.open()
        let sequence = try fileDeserializer.deserialize(jsonStream: fileStream)
        fileStream.close()
        progressPolling.invalidate()
        print("Closed filestream.")
        
        return sequence
    }

    private func saveOutput(of dataStream: AsyncStream<LocationDatum>) async throws {
        let fileSize = fileStreamProgress?.totalUnitCount ?? 0
        let estimatedNumberOfDatums =  fileSize / Constants.estimatedDatumByteSize
        let deserializationProgress = Progress(totalUnitCount: estimatedNumberOfDatums)
        progress.addChild(deserializationProgress, withPendingUnitCount: 60)
      
        var batch: [LocationDatum] = []
        for try await datum in dataStream {
            batch.append(datum)
            if batch.count > Constants.batchSize {
                deserializationProgress.completedUnitCount += 1
                let request = BatchLocationDatumInsertRequest(data: batch)
                try await database.execute(request)
                deserializationProgress.completedUnitCount += Constants.batchSize
                batch = []
            }
        }
        print("Import finished")
    }
    
    private func queryFileStreamProgress() {
        guard let offsetNSNumber = fileStream.property(forKey: .fileCurrentOffsetKey) as? NSNumber else { return }
        let offset = offsetNSNumber.int64Value
        fileStreamProgress?.completedUnitCount = offset
    }
    
    private func logImportSource() async throws {
        let request = InsertImportSourceRequest(importSource: importSource)
        try await database.execute(request)
    }
}
