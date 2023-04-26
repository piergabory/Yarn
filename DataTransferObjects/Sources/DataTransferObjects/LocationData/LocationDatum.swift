//
//  File.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import Foundation

public struct LocationDatum {
    public let latitude: Double
    public let longitude: Double
    public let date: Date
    public let duration: TimeInterval
    public let distance: Double
    public let speed: Double
    
    public init(
        latitude: Double,
        longitude: Double,
        date: Date,
        duration: TimeInterval,
        distance: Double,
        speed: Double
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.duration = duration
        self.distance = distance
        self.speed = speed
    }
}
