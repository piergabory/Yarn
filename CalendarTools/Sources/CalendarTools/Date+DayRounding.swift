//
//  File.swift
//  
//
//  Created by Pierre Gabory on 09/04/2023.
//

import Foundation

extension Date {
    
    private static let calendar = Calendar.current

    public var isToday: Bool {
        Self.calendar.isDateInToday(self)
    }
    
    // Round to day limits
    
    public var startOfDay: Date {
        Self.calendar.date(
            bySettingHour: 0, minute: 0, second: 0,
            of: self,
            matchingPolicy: .nextTime,
            direction: .backward
        ) ?? self - 12.hours
    }
    
    public var endOfDay: Date {
        Self.calendar.date(
            bySettingHour: 23, minute: 59, second: 59,
            of: self,
            matchingPolicy: .nextTime,
            direction: .forward
        ) ?? self + 12.hours
    }
    
    public var midday: Date {
        Self.calendar.date(
            bySettingHour: 12, minute: 0, second: 0,
            of: self,
            matchingPolicy: .nextTime,
            direction: .forward
        ) ?? self
    }
}
