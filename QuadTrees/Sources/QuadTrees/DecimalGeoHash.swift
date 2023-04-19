//
//  File.swift
//  
//
//  Created by Pierre Gabory on 20/04/2023.
//

import Foundation

public typealias DecimalGeoHash = [UInt32]

extension DecimalGeoHash {
    
    private static let geoHashAlphabet = [
        "0", "1", "2", "3", "4", "5", "6", "7",
        "8", "9", "b", "c", "d", "e", "f", "g",
        "h", "j", "k", "m", "n", "p", "q", "r",
        "s", "t", "u", "v", "w", "x", "y", "z"
    ]
    
    public var stringGeoHash: String {
        map({ DecimalGeoHash.geoHashAlphabet[Int($0)] }).joined()
    }
}
