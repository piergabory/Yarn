//
//  SubticksMarks.swift
//  
//
//  Created by Pierre Gabory on 24/05/2023.
//

import SwiftUI

struct SubticksMarks: View {
    let levels: [Int]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                ForEach(Array(levels.enumerated()), id: \.element) { level, count in
                    let height = proxy.size.height / pow(2, CGFloat(level))
                    TickMarks(count: count)
                        .frame(height: height)
                        .foregroundColor(level == 0 ? .primary : .secondary)
                }
            }
        }
    }
}

struct SubticksMarks_Previews: PreviewProvider {
    static var previews: some View {
        SubticksMarks(levels: [3, 9])
    }
}
