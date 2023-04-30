//
//  GoogleTimelineDeserializer.swift
//  
//
//  Created by Pierre Gabory on 28/03/2023.
//

import Foundation
import DataTransferObjects

public typealias GoogleTimelineDeserializer = JSONStreamDeserializer<GoogleTimelineTimedCoordinatesDeserializer>

public extension GoogleTimelineDeserializer {
    init() {
        self.init(
            arrayPropertyPath: ["locations"],
            itemDeserializer: GoogleTimelineTimedCoordinatesDeserializer()
        )
    }
}

// Map Google location data item to shared dto
public struct GoogleTimelineTimedCoordinatesDeserializer: JSONObjectDeserializer {
    
    private enum Keys {
        static let latitude = "latitudeE7"
        static let longitude = "longitudeE7"
        static let timestamp = "timestamp"
    }
    
    enum CoordinatesDeserializationError: Error {
        case invalidObject(String)
        case invalidTimestampValue(String)
    }
    
    private let isoDateFormater = ISO8601DateFormatter()
    private let isoMillisecondDateFormater = ISO8601DateFormatter()
    
    public init() {
        isoDateFormater.formatOptions = [.withInternetDateTime]
        isoMillisecondDateFormater.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    }
    
    public func deserialize(_ jsonObject: NSDictionary) throws -> TimedCoordinates {
        guard
            let latitude = jsonObject[Keys.latitude] as? Int,
            let longitude = jsonObject[Keys.longitude] as? Int,
            let timestamp = jsonObject[Keys.timestamp] as? String
        else { throw CoordinatesDeserializationError.invalidObject(jsonObject.description) }
        
        return TimedCoordinates(
            latitude: Double(latitude) / 10e6,
            longitude: Double(longitude) / 10e6,
            date: try decode(timestampString: timestamp)
        )
    }
    
    private func decode(timestampString: String) throws -> Date {
        let date = isoDateFormater.date(from: timestampString) ?? isoMillisecondDateFormater.date(from: timestampString)
        if let date {
            return date
        } else {
            throw CoordinatesDeserializationError.invalidTimestampValue(timestampString)
        }
    }
}
