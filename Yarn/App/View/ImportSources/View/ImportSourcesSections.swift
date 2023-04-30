//
//  ImportSourcesSections.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI

struct ImportSourcesSections: View {
    @Environment(\.managedObjectContext)
    var managedObjectContext
    
    @StateObject
    var importSourcesRepository = ImportSourcesRepository()
    
    var body: some View {
        Section {
            SourceDistributionView(sources: importSourcesRepository.sources)
            ForEach(importSourcesRepository.sources) { source in
                ImportSourceView(source: source)
            }
        } header: {
            Label("Sources", systemImage: "doc.fill")
        }
        .onAppear {
            importSourcesRepository.set(context: managedObjectContext)
        }
    }
}

//struct ImportSourcesSections_Previews: PreviewProvider {
//    static var previews: some View {
//        List {
//            ImportSourcesSections()
//        }.environment(\.managedObjectContext, NSManagedObjectContext())
//    }
//}
