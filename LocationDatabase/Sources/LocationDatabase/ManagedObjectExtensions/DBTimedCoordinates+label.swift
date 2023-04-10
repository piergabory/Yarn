//
//  File.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import Foundation
import CoreData

extension DBTimedCoordinates {
    
    public enum Label: Int16 {
        case unspecified
        case nullCoordinate
    }
    
    
    public var label: Label {
        get { Label(rawValue: rawLabel) ?? .unspecified }
        set { rawLabel = newValue.rawValue }
    }
    
    public static func makeBatchUpdateRequest(label: Label) -> NSBatchUpdateRequest {
        let request = NSBatchUpdateRequest(entity: entity())
        request.propertiesToUpdate = [#keyPath(DBTimedCoordinates.rawLabel): label.rawValue]
        return request
    }
}
