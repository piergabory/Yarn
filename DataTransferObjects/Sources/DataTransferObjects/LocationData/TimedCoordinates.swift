//
//  TimedCoordinates.swift
//  
//
//  Created by Pierre Gabory on 31/03/2023.
//

import Foundation

public struct TimedCoordinates {
    public let latitude: Double
    public let longitude: Double
    public let date: Date
    
    public init(latitude: Double, longitude: Double, date: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
}
