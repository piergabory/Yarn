//
//  ContentView.swift
//  Shared
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MapView(path: [])
                .ignoresSafeArea()
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
                        DatePicker("Start", selection: $startDate, displayedComponents: .date)
                        DatePicker("End", selection: $endDate, displayedComponents: .date)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewLayout(.sizeThatFits)
    }
}
