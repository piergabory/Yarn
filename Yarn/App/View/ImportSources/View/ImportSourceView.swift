//
//  ImportSourceView.swift
//  Yarn
//
//  Created by Pierre Gabory on 26/04/2023.
//

import SwiftUI
import DataTransferObjects

struct ImportSourceView: View {
    let source: ImportSource
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(source.fileURL.lastPathComponent)
                .font(.headline)
            
            Group {
                Text("Imported on: ") + Text(source.importDate, format: .dateTime)
                if let count = source.datumCount {
                    Text("Number of points: ") + Text(count, format: .number)
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
}

struct ImportSourceView_Previews: PreviewProvider {
    
    static let source = ImportSource(fileURL: URL(string: "/toto")!, importDate: .now, datumCount: 12345)
    
    static var previews: some View {
        ImportSourceView(source: source)
    }
}
