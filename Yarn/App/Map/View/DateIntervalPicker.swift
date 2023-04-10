//
//  DateIntervalPicker.swift
//  Yarn
//
//  Created by Pierre Gabory on 09/04/2023.
//

import SwiftUI

struct DateIntervalPicker: View {
    @Binding var selection: DateInterval
    
    var body: some View {
        VStack {
            DatePicker("Start", selection: $selection.start)
            DatePicker("End", selection: $selection.end)
        }
    }
}

struct DateIntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        DateIntervalPicker(
            selection: .constant(DateInterval(
                start: .now,
                duration: 1000)
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
