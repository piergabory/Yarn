//
//  File.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import CoreData
import DataTransferObjects
import Foundation

public struct ImportSourceTransformer: DTOTransformer {
    
    public func convert(_ dbImportSource: DBImportSource) throws -> ImportSource {
        if let fileURL = dbImportSource.fileURL, let importDate = dbImportSource.importDate {
            return ImportSource(fileURL: fileURL, importDate: importDate)
        } else {
            throw DTOUpdatorError.invalidDatabaseObject(dbImportSource)
        }
    }
    
    public func update(_ dbImportSource: DBImportSource, with importSource: ImportSource) throws {
        dbImportSource.fileURL = importSource.fileURL
        dbImportSource.importDate = importSource.importDate
    }
}
