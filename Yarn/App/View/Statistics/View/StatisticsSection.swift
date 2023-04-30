//
//  StatisticsSection.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI

struct StatisticsSection: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var statistics = StatisticsRepository()
    
    var body: some View {
        Section {
            MovementStatisticsView(movementData: statistics.movementDataPoint)
            StatisticsItemView(
                definition: "Number of locations",
                value: statistics.numberOfLocations,
                format: .number
            )
//            if let maxSpeed = statistics.maximumSpeed {
//                StatisticsItemView(
//                    definition: "Maximum Speed",
//                    value: Measurement(value: maxSpeed, unit: .metersPerSecond),
//                    format: .measurement(width: .abbreviated)
//                )
//            }
            if let lastDate = statistics.lastMeasurementDate {
                StatisticsItemView(
                    definition: "Oldest Measurement",
                    value: lastDate,
                    format: .dateTime
                )
            }
            if let firstDate = statistics.firstMeasurementDate {
                StatisticsItemView(
                    definition: "Newest Measurement",
                    value: firstDate,
                    format: .dateTime
                )
            }
        } header: {
            Label(
                "Statistics",
                systemImage: "chart.bar.fill"
            )
        }
        .onAppear {
            statistics.managedObjectContext = managedObjectContext
        }
    }
}

struct DatabaseStatisticsSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            StatisticsSection()
        }
    }
}
