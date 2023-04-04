//
//  StatisticsView.swift
//  Yarn
//
//  Created by Pierre Gabory on 04/04/2023.
//

import SwiftUI
import CoreData
import LocationDatabase

struct StatisticsView: View {
  
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)])
    private var locationData: FetchedResults<DBLocationDatum>
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 8) {
                Text("Total location datums.")
                Text(locationData.endIndex, format: .number)
                    .fontWeight(.bold)
            }
            if let firstDate = locationData.first?.date {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Oldest location info")
                    Text(firstDate, format: .dateTime)
                        .fontWeight(.bold)
                }
            }
            if let lastDate = locationData.last?.date {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Most recent location info")
                    Text(lastDate, format: .dateTime)
                        .fontWeight(.bold)
                }
            }
        }
            .navigationTitle("Statistics")
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
