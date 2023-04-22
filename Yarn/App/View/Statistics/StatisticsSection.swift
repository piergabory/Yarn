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
