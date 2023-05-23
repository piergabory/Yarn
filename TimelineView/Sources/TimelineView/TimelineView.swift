//
//  TimelineView.swift
//  
//
//  Created by Pierre Gabory on 23/05/2023.
//

import SwiftUI

struct TimelineView: View {
    @State var stateOffset: CGFloat = 0
    @State var gestureOffset: CGFloat = 0
    var offset: CGFloat { stateOffset + gestureOffset }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * (1 + 1/6)
            let height = geometry.size.height
            let periodicity = width / 12
            let renderingOffset = offset.remainder(dividingBy: periodicity)
            
            subtickedRuler
                .frame(width: width, height: height)
                .offset(CGSize(width: renderingOffset - periodicity, height: 0))
        }
        .gesture(panGesture)
    }
    
    var panGesture: some Gesture { DragGesture()
        .onChanged { gestureState in
            gestureOffset = gestureState.translation.width
        }
        .onEnded { gestureState in
            stateOffset += gestureState.translation.width
            gestureOffset = 0
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
