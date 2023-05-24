//
//  Ruler.swift
//  
//
//  Created by Pierre Gabory on 24/05/2023.
//

import SwiftUI

struct Ruler<MarkData: RandomAccessCollection, MarkFormat: FormatStyle>: View
where
    MarkData.Element: Hashable,
    MarkData.Element == MarkFormat.FormatInput,
    MarkFormat.FormatOutput == String
{
    private let rows = [
        GridItem(),
        GridItem(.flexible(minimum: 20)),
    ]
    
    private let markData: MarkData
    private let markFormat: MarkFormat
    private let origin: MarkData.Element?
    private let subticks: [Int]
    
    init(
        _ markData: MarkData,
        format: MarkFormat,
        origin: MarkData.Element? = nil,
        subticksBetweenMarks: [Int] = [2, 8]
    ) {
        self.markData = markData
        self.markFormat = format
        self.origin = origin
        self.subticks = subticksBetweenMarks
    }
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, spacing: 0) {
                    ForEach(markData, id: \.self) { value in
                        Text(value, format: markFormat)
                            .offset(x: -100)
                        SubticksMarks(levels: subticks)
                            .frame(width: 200)
                            .id(value)
                    }
                }
            }
            .onAppear { resetToOrigin(scrollProxy) }
            .onTapGesture(count: 2) { resetToOrigin(scrollProxy) }
        }
    }
    
    private func resetToOrigin(_ scrollProxy: ScrollViewProxy) {
        if let origin {
            scrollProxy.scrollTo(origin, anchor: .center)
        }
    }
}

struct Ruler_Previews: PreviewProvider {
    static var previews: some View {
        Ruler(-30...30, format: .number, origin: 0)
    }
}
