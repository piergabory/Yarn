//
//  FetchRequest.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import CoreData
import Foundation

public struct FetchRequest<Convertor: DTOConvertor>: Request {
    let convertor: Convertor
    let request: NSFetchRequest<Convertor.DBO>
    
    init(convertor: Convertor) {
        self.convertor = convertor
        self.request = NSFetchRequest()
        request.entity = Convertor.DBO.entity()
    }
    
    public func execute(in context: NSManagedObjectContext) async throws -> [Convertor.DTO] {
        try await context.perform {
            try context
                .fetch(request)
                .map(convertor.convert)
        }
    }
    
    @discardableResult
    func set(predicate: NSPredicate) -> Self {
        request.predicate = predicate
        return self
    }
    
    @discardableResult
    func set(sortDescriptor: NSSortDescriptor) -> Self {
        set(sortDescriptors: [sortDescriptor])
    }
    
    @discardableResult
    func set(sortDescriptors: [NSSortDescriptor]) -> Self {
        request.sortDescriptors = sortDescriptors
        return self
    }
}
