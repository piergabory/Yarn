//
//  TickMarks.swift
//  
//
//  Created by Pierre Gabory on 24/05/2023.
//

import SwiftUI

struct TickMarks: View {
    private let ticks: Int
    private let strokeStyle: StrokeStyle
    
    init(count: Int, strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1)) {
        self.ticks = count
        self.strokeStyle = strokeStyle
    }
    
    var body: some View {
        Canvas { context, size in
            let spacing = size.width / CGFloat(ticks)
            var path = Path()
            for index in 0...ticks {
                let position = CGFloat(index) * spacing
                path.move(to: CGPoint(x: position, y: 0))
                path.addLine(to: CGPoint(x: position, y: size.height))
            }
            context.stroke(path, with: .foreground, style: strokeStyle)
        }
    }
}

struct TickMarks_Previews: PreviewProvider {
    static var previews: some View {
        TickMarks(count: 10)
    }
}
