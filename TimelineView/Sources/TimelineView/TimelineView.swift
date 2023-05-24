//
//  TimelineView.swift
//  
//
//  Created by Pierre Gabory on 23/05/2023.
//

import SwiftUI

public extension TimeInterval {
    var seconds: TimeInterval { self }
    var minutes: TimeInterval { seconds * 60 }
    var hours: TimeInterval { minutes * 60 }
    var days: TimeInterval { hours * 24 }
}

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
        case ..<1.minutes:
            return Date.FormatStyle(time: .standard)
        case 1.minutes..<1.days:
            return Date.FormatStyle(time: .shortened)
        case 1.days..<200.days:
            return Date.FormatStyle().day(.defaultDigits).month(.abbreviated)
        case 200.days..<364.25.days:
            return Date.FormatStyle(date: .abbreviated)
        case 364.25.days...:
            return Date.FormatStyle().year()
        default:
            return Date.FormatStyle(date: .numeric, time: .shortened)
        }
    }
    
    var subticks: [Int] {
        switch markInterval {
        case 1.minutes:
            return [2, 60]
        case 15.minutes:
            return [3, 15]
        case 30.minutes:
            return [2, 30]
        case 1.hours:
            return [4, 60]
        case 12.hours:
            return [2, 12]
        case 1.days:
            return [4, 24]
        case 7.days:
            return [7, 28]
        case 28.days:
            return [7, 28]
        case 364.25.days:
            return [4, 12]
        case 3642.5.days:
            return [10]
        default:
            return [2]
        }
    }
    
    var body: some View {
        Ruler(
            timelineData,
            format: format,
            origin: origin,
            subticksBetweenMarks: subticks
        )
    }
}

struct TimelineView_Previews: PreviewProvider {
    static let date = Date(timeIntervalSinceReferenceDate: 0)
    
    static var previews: some View {
        List {
            Group {
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 100.minutes),
                    markInterval: 1.minutes
                )
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 100.minutes),
                    markInterval: 15.minutes
                )
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 100.minutes),
                    markInterval: 30.minutes
                )
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 100.hours),
                    markInterval: 1.hours
                )
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 100.hours),
                    markInterval: 12.hours
                )
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 100.days),
                    markInterval: 1.days
                )
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 1000.days),
                    markInterval: 7.days
                )
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 1000.days),
                    markInterval: 28.days
                )
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 10000.days),
                    markInterval: 364.25.days
                )
                TimelineView(
                    dateInterval: DateInterval(start: date, duration: 100000.days),
                    markInterval: 3642.5.days
                )
            }
            .padding(.vertical)
        }
    }
}
