//
//  Request.swift
//  
//
//  Created by Pierre Gabory on 28/03/2023.
//

import CoreData
import Foundation

public protocol Request {
    associatedtype ResultType
    func execute(in context: NSManagedObjectContext) async throws -> ResultType
}
