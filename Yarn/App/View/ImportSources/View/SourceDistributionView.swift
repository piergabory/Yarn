//
//  SourceDistributionView.swift
//  Yarn
//
//  Created by Pierre Gabory on 26/04/2023.
//

import Charts
import DataTransferObjects
import SwiftUI

struct SourceDistributionView: View {
    
    let sources: [ImportSource]
    
    var body: some View {
        Chart {
            ForEach(sources) { source in
                BarMark(x: .value("Count", source.datumCount ?? 0))
            }
        }
        .frame(height: 40)
    }
}

struct SourceDistributionView_Previews: PreviewProvider {
    static var previews: some View {
        SourceDistributionView(sources: [])
    }
}
