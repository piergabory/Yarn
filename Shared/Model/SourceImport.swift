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
    private var task: AnyCancellable!
    let fileName: String
    var totalBytes: Int
    @Published var completedBytes = 0
    var progress: Double { Double(completedBytes) / Double(totalBytes) }
    
    init(filePath: URL, saveIn managedObjectContext: NSManagedObjectContext) throws {
        fileName = filePath.lastPathComponent
        let totalBytes = try FileManager.default.attributesOfItem(atPath: filePath.path)[.size] as! Int
        self.totalBytes = totalBytes
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.task = (0...totalBytes).publisher
                .collect(1000000)
                .map(\.last!)
                .throttle(for: .milliseconds(300), scheduler: RunLoop.main, latest: true)
                .sink { [weak self] in self?.completedBytes = $0 }
        }
    }
    
    static var preview = SourceImport()
    
    private init() {
        fileName = "Preview file import"
        totalBytes = 1000000000
        completedBytes = 400000000
    }
    
    deinit {
        task.cancel()
    }
    
    private func decode(stream: InputStream) {
        
    }
}
