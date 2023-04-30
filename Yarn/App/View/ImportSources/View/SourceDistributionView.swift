//
//  SourceDistributionView.swift
//  Yarn
//
//  Created by Pierre Gabory on 26/04/2023.
//

import Charts
import SwiftUI

struct SourceDistributionView: View {
    
    var body: some View {
        Chart {
            BarMark(x: .value("Location Data", 100))
        }
        .frame(height: 40)
    }
}

struct SourceDistributionView_Previews: PreviewProvider {
    static var previews: some View {
        SourceDistributionView()
    }
}
