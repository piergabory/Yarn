//
//  StatisticsSection.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI

struct StatisticsSection: View {
    var body: some View {
        Section {
            MovementStatisticsView()
            StatisticsItemView(
                definition: "Number of locations",
                value: 23448237409,
                format: .number
            )
            StatisticsItemView(
                definition: "Maximum Speed",
                value: Measurement(value: 120, unit: UnitSpeed.metersPerSecond),
                format: .measurement(width: .abbreviated)
            )
            StatisticsItemView(
                definition: "Oldest Measurement",
                value: Date(timeIntervalSinceReferenceDate: 0),
                format: .dateTime
            )
            StatisticsItemView(
                definition: "Newest Measurement",
                value: Date.now,
                format: .dateTime
            )
        } header: {
            Label(
                "Statistics",
                systemImage: "chart.bar.fill"
            )
        }
    }
}

import Charts

struct MovementStatisticsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Movements")
                .font(.headline)
            Chart {
                BarMark(x: .value("Category", "A"), y: .value("Value", 1))
                BarMark(x: .value("Category", "B"), y: .value("Value", 2))
                BarMark(x: .value("Category", "C"), y: .value("Value", 3))
                BarMark(x: .value("Category", "D"), y: .value("Value", 2))
                BarMark(x: .value("Category", "E"), y: .value("Value", 3))
                BarMark(x: .value("Category", "F"), y: .value("Value", 1))
            }
        }
    }
}

struct StatisticsItemView<Format: FormatStyle>: View
    where Format.FormatInput: Equatable, Format.FormatOutput == String
{
    let definition: String
    let value: Format.FormatInput
    let format: Format
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(definition)
                .font(.headline)
            Text(value, format: format)
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
