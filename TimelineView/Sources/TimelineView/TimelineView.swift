//
//  TimelineView.swift
//  
//
//  Created by Pierre Gabory on 23/05/2023.
//

import SwiftUI

struct TimelineView: View {
    @State var scale: CGFloat = 1
    let span = -10000...10000
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center, spacing: 0) {
                    ForEach(span, id: \.self) { index in
                        VStack {
                            Text(index, format: .number)
                            subtickedRuler
                        }
                            .frame(width: 200 * scale)
                            .id(index)
                    }
                }
            }
            .onAppear {
                scrollProxy.scrollTo(0, anchor: .center)
            }
            .gesture(pinchGesture)
            .onTapGesture(count: 2) {
                scrollProxy.scrollTo(0, anchor: .center)
            }
        }
    }
    
    var pinchGesture: some Gesture {
        MagnificationGesture()
            .onChanged { scale in
                self.scale = scale
            }
    }
    
    var subtickedRuler: some View {
        ZStack(alignment: .center) {
            Ruler(ticks: 12)
                .frame(height: 30)
            Ruler(ticks: 48)
                .frame(height: 15)
                .foregroundColor(.secondary)
        }
    }
}



struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
            .previewLayout(.fixed(width: 300, height: 80))
    }
}
