//
//  ContentView.swift
//  Shared
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = MapViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MapView(path: model.coordinates)
                .ignoresSafeArea()
            MapControls(model: model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewLayout(.sizeThatFits)
    }
}

struct MapControls: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @ObservedObject var model: MapViewModel
    
    var body: some View {
        VStack {
            Group {
                VStack(alignment: .leading) {
                    Text("Yarn")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Displayed locations")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Divider()
                    DatePicker("Start", selection: $model.startDate, in: model.startDateRange, displayedComponents: .date)
                    DatePicker("End", selection: $model.endDate, in: model.endDateRange, displayedComponents: .date)
                    Button("Update") { model.updateMap(withDataFrom: managedObjectContext) }
                }
                ImporterView()
            }
            .frame(width: 300)
            .padding()
            .background(Color("CardBackground"))
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}
