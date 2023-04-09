//
//  Ruler.swift
//  
//
//  Created by Pierre Gabory on 09/04/2023.
//

import SwiftUI

struct Ruler: View {
    let ticks: [Int]
    
    init(ticks: [Int]) {
        self.ticks = ticks.reduce([]) { acc, value in
            let count = (acc.last ?? 1) * value
            if count < 200 {
                return acc + [count]
            } else {
                return acc
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ForEach(Array(ticks.enumerated()), id: \.offset) { pair in
                    subticks(count: pair.element)
                        .frame(height: geometry.size.height / CGFloat(pair.offset + 1))
                }
            }
        }
    }
    
    func subticks(count: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<count, id: \.self) { _ in
                Rectangle()
                    .frame(width: 1)
                    .padding(.trailing, -1)
                Spacer()
                    .background(Color.clear)
            }
        }
    }
}

struct Ruler_Previews: PreviewProvider {
    static var previews: some View {
        Ruler(ticks: [10, 5, 2])
            .previewLayout(.fixed(width: 300, height: 40))
    }
}
