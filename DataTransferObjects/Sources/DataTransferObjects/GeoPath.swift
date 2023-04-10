//
//  GeoPath.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import Foundation

public struct GeoPath {
    public let startDate: Date
    public let endDate: Date
    
    public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
