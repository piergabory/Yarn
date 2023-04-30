//
//  StatisticsItemView.swift
//  Yarn
//
//  Created by Pierre Gabory on 30/04/2023.
//

import SwiftUI

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


struct StatisticsItemView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsItemView(definition: "Test", value: 10, format: .number)
    }
}
