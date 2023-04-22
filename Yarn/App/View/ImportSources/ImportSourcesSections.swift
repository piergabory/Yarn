//
//  ImportSourcesSections.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI

struct ImportSourcesSections: View {
    var body: some View {
        Section() {
            ImportSourceView(
                sourceName: "Records.json",
                importDate: .now,
                locationDataCount: 203930
            )
        } header: {
            Label(
                "Sources",
                systemImage: "doc.fill"
            )
        }
    }
}

struct ImportSourceView: View {
    let sourceName: String
    let importDate: Date
    let locationDataCount: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(sourceName)
                .font(.headline)
            
            Group {
                Text("Imported on: ")
                + Text(importDate, format: .dateTime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Number of points: ")
                + Text(locationDataCount, format: .number)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
}

struct ImportSourcesSections_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ImportSourcesSections()
        }
    }
}
