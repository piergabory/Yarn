//
//  MovementStatisticsView.swift
//  Yarn
//
//  Created by Pierre Gabory on 30/04/2023.
//

import SwiftUI
import Charts

struct MovementStatisticsView: View {
    let movementData: [StatisticsRepository.MovementDataPoint]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Movements")
                .font(.headline)
            Chart {
                ForEach(movementData) { datum in
                    LineMark(
                        x: .value("Date", datum.date),
                        y: .value("Movement", datum.distance)
                    )
                }
            }
        }
    }
}

struct MovementStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        MovementStatisticsView(movementData: [])
    }
}
