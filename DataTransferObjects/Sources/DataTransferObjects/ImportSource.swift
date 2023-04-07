//
//  File.swift
//  
//
//  Created by Pierre Gabory on 07/04/2023.
//

import Foundation

public struct ImportSource: Hashable {
    public let fileURL: URL
    public let importDate: Date
    
    public init(fileURL: URL, importDate: Date) {
        self.fileURL = fileURL
        self.importDate = importDate
    }
}
