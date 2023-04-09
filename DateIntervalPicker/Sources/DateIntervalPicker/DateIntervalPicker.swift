//
//  DateIntervalPicker.swift
//  
//
//  Created by Pierre Gabory on 09/04/2023.
//

import SwiftUI

struct DateIntervalPicker: View {
    @Binding var selection: DateInterval
    let boundaries: DateInterval
    
    @State var position: CGFloat = 0
//    @State var scale: CGFloat = 0
    
    var body: some View {
        Ruler(ticks: [10, 5, 2])
            .offset(x: position)
            
            .frame(height: 100)
            .gesture(
                DragGesture()
                    .onChanged { position = $0.translation.width }
            )
    }
}

struct DateIntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        DateIntervalPicker(
            selection: .constant(DateInterval(start: .now, duration: 1000)),
            boundaries: DateInterval(start: .now - 100, end: .now + 2000)
        )
            .previewLayout(.sizeThatFits)
    }
}
