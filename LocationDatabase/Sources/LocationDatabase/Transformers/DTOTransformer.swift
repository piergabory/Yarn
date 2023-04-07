//
//  File.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import CoreData
import Foundation

typealias DTOTransformer = DTOConvertor & DTOUpdator

public protocol DTOConvertor {
    associatedtype DBO: NSManagedObject
    associatedtype DTO

    func convert(_: DBO) -> DTO
    func update(_: DBO, with: DTO)
}

public protocol DTOUpdator {
    associatedtype DBO: NSManagedObject
    associatedtype DTO

    func update(_: DBO, with: DTO)
}
