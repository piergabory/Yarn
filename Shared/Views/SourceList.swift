//
//  SourceList.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import CoreData
import SwiftUI

struct SourceList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Source.date, ascending: true)])
    private var sources: FetchedResults<Source>

    var body: some View {
        Section(header: Text("Sources")) {
            ForEach(sources) { source in
                SourceView(source)
            }
            if sources.isEmpty {
                Text("Start by importing.")
                    .foregroundColor(.secondary)
            }
        }
    }
}

private struct SourceView: View {
    private let source: Source
    private let dateformatter = DateFormatter()
    
    init(_ source: Source) {
        self.source = source
        dateformatter.dateStyle = .medium
        dateformatter.doesRelativeDateFormatting = true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(source.name ?? "Unkown")
                .font(.headline)
            Text(subheadline)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var subheadline: String {
        [
            dateformatter.string(from: source.date!),
            "Imported \(source.locations?.count ?? 0) locations."
        ].joined(separator: " - ")
    }
}

// MARK: - Preview

struct SourceList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                SourceList()
            }
                .environment(\.managedObjectContext,  PersistenceController.preview.container.viewContext)
            
            List {
                SourceList()
            }
        }
    }
}
