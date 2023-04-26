//
//  File.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import Foundation

public struct ImportSource: Hashable, Identifiable {
    public let fileURL: URL
    public let importDate: Date
    public let datumCount: Int?
    
    public var id: String { fileURL.absoluteString }
    
    public init(fileURL: URL, importDate: Date, datumCount: Int? = nil) {
        self.fileURL = fileURL
        self.importDate = importDate
        self.datumCount = datumCount
    }
}
