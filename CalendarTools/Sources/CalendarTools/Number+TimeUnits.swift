//
//  File.swift
//  
//
//  Created by Pierre Gabory on 09/04/2023.
//

import Foundation

public extension BinaryInteger {
    var seconds: TimeInterval { TimeInterval(self) }
    var minutes: TimeInterval { seconds / 60 }
    var hours: TimeInterval { minutes / 60 }
}

public extension BinaryFloatingPoint {
    var seconds: TimeInterval { TimeInterval(self) }
    var minutes: TimeInterval { seconds / 60 }
    var hours: TimeInterval { minutes / 60 }
}
