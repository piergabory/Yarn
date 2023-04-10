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
  
    @SwiftUI.FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)])
    private var rawCoordinates: FetchedResults<DBTimedCoordinates>
    
    @SwiftUI.FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)])
    private var locationData: FetchedResults<DBLocationDatum>
    
    @SwiftUI.FetchRequest(sortDescriptors: [SortDescriptor(\.importDate, order: .forward)])
    private var sources: FetchedResults<DBImportSource>
    
    @SwiftUI.FetchRequest(sortDescriptors: [SortDescriptor(\.startDate, order: .forward)])
    private var paths: FetchedResults<DBPath>
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total paths.")
                    Text(paths.endIndex, format: .number)
                        .fontWeight(.bold)
                }
            }
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total location coordinatess.")
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
                if let maxSpeed = locationData.map(\.speed).max() {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Max speed")
                        Text(maxSpeed, format: .number)
                            .fontWeight(.bold)
                    }
                }
                if let maxSpeed = locationData.map(\.speed).min() {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Min speed")
                        Text(maxSpeed, format: .number)
                            .fontWeight(.bold)
                    }
                }
            }
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total location coordinatess.")
                    Text(rawCoordinates.endIndex, format: .number)
                        .fontWeight(.bold)
                }
                if let firstDate = rawCoordinates.first?.date {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Oldest location info")
                        Text(firstDate, format: .dateTime)
                            .fontWeight(.bold)
                    }
                }
                if let lastDate = rawCoordinates.last?.date {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Most recent location info")
                        Text(lastDate, format: .dateTime)
                            .fontWeight(.bold)
                    }
                }
            }
            Section {
                ForEach(sources) { dbImportSource in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(dbImportSource.fileURL?.lastPathComponent ?? "null")
                        if let date = dbImportSource.importDate {
                            Text(date, format: .dateTime)
                        }
                    }
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
