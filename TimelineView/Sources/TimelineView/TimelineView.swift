//
//  TimelineView.swift
//  
//
//  Created by Pierre Gabory on 23/05/2023.
//

import SwiftUI

struct TimelineView: View {
    let dateInterval: DateInterval
    let markInterval: TimeInterval
    
    var timelineData: [Date] {
        Array(stride(from: dateInterval.start, to: dateInterval.end, by: markInterval))
    }
    
    var origin: Date {
        min(max(dateInterval.start, .now), dateInterval.end)
    }
    
    var format: Date.FormatStyle {
        switch markInterval {
        case ..<60:
            return Date.FormatStyle(date: .none, time: .standard)
        case 60..<(3600 * 24):
            return Date.FormatStyle(date: .none, time: .shortened)
        default:
            return Date.FormatStyle(date: .abbreviated, time: .none)
        }
    }
    
    var body: some View {
        Ruler(timelineData, format: format, origin: origin)
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(
            dateInterval: DateInterval(start: .now - 1000000, end: .now + 1000000),
            markInterval: 400000
        )
            .previewLayout(.fixed(width: 300, height: 80))
    }
}
