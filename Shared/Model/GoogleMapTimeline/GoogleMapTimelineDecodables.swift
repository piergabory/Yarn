//
//  File.swift
//  
//
//  Created by Pierre Gabory on 25/10/2020.
//

import Foundation

enum GoogleMapTimeline {
    
    struct Location: Decodable {
        
        // JSON values
        
        private let timestampMs: String
        private let latitudeE7: Int
        private let longitudeE7: Int
        
        let accuracy: Int
        let altitude: Int?
        let verticalAccuracy: Int?
        
        let activity: [Activity]?
        
        // Converted types
        
        private var timestamp: TimeInterval { Double(timestampMs)! * 0.001 }
        
        var date: Date { Date(timeIntervalSince1970: timestamp) }
        var latitude: Double { latitudeE7.E7Precision }
        var longitude: Double { longitudeE7.E7Precision }
    }
    
    struct Activity: Decodable {
        
        enum ActivityTypeName: String, Decodable {
            case unknown = "UNKNOWN"
            case still = "STILL"
            case tilting = "TILTING"
            case onFoot = "ON_FOOT"
            case onBicycle = "ON_BICYCLE"
            case inVehicle = "IN_VEHICLE"
            case walking = "WALKING"
            case running = "RUNNING"
            case exitingVehicle = "EXITING_VEHICLE"
            case inRailVehicle = "IN_RAIL_VEHICLE"
            case inRoadVehicle = "IN_ROAD_VEHICLE"
        }
        
        struct ActivityType: Decodable {
            let type: ActivityTypeName
            let confidence: Int
        }
        
        private let timestampMs: String
        
        let activity: [ActivityType]
        
        var timestamp: TimeInterval { Double(timestampMs)! * 0.001 }
        var date: Date { Date(timeIntervalSince1970: timestamp) }
    }
}

private extension Int {
    var E7Precision: Double { Double(self) * 0.0000001 }
}
