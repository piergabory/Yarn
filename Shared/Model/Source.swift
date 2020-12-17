//
//  Source.swift
//  Yarn
//
//  Created by Pierre Gabory on 17/12/2020.
//

import Foundation

extension Source {
    
    var sortedLocations: [Location] {
        let sortDescriptors = [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)]
        guard
            let anyArray = locations?.sortedArray(using: sortDescriptors),
            let locationArray = anyArray as? [Location] else {
            return []
        }
        return locationArray
    }
}
