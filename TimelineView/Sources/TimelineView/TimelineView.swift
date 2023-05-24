//
//  TimelineView.swift
//  
//
//  Created by Pierre Gabory on 23/05/2023.
//

import SwiftUI

struct TimelineView: View {
    let span = -1000...1000
    
    var body: some View {
        Ruler(span, format: .number, origin: 0)
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
            .previewLayout(.fixed(width: 300, height: 80))
    }
}
