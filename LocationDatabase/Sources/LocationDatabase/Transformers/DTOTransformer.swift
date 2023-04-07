//
//  File.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import CoreData
import Foundation

enum DTOUpdatorError: Error {
    case invalidDatabaseObject(NSManagedObject)
}

public typealias DTOTransformer = DTOConvertor & DTOUpdator

public protocol DTOConvertor {
    associatedtype DBO: NSManagedObject
    associatedtype DTO

    func convert(_: DBO) throws -> DTO
}

public protocol DTOUpdator {
    associatedtype DBO: NSManagedObject
    associatedtype DTO

    func update(_: DBO, with: DTO) throws
}
