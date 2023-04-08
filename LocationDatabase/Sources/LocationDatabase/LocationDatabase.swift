//
//  LocationDatabase.swift
//  
//
//  Created by Pierre Gabory on 28/03/2023.
//

import Foundation
import CoreData

// Holds reference to the DB container

public final class LocationDatabase {
    enum Error: Swift.Error {
        case momdRessourceURLNotFound
        case failedToBuildModel(URL)
    }
    
    private var didLoadPersistentStores = false
    private let persistentContainer: NSPersistentContainer
    private lazy var transactionContext = persistentContainer.newBackgroundContext()
    
    public var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    public static let main = try! LocationDatabase()
    
    public init() throws {
        guard
            let modelURL = Bundle.module.url(forResource:"Location", withExtension: "momd")
        else { throw Error.momdRessourceURLNotFound }

        guard
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else { throw Error.failedToBuildModel(modelURL) }

        persistentContainer = NSPersistentContainer(name: "Location", managedObjectModel: model)
    }
    
    @discardableResult
    public func execute<R: Request>(_ request: R) async throws -> R.ResultType {
        if didLoadPersistentStores == false {
            try await loadPersistentStores()
        }
        return try await request.execute(in: viewContext)
    }
    
    public func loadPersistentStores() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Swift.Error>) in
            persistentContainer.loadPersistentStores { [weak self] _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    self?.didLoadPersistentStores = true
                    continuation.resume()
                }
            }
        }
    }
}
