//
//  ImportView.swift
//  Yarn
//
//  Created by Pierre Gabory on 15/12/2020.
//

import SwiftUI

struct ImportView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @ObservedObject var importTask: Import
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(importTask.fileName).font(.headline)
                Spacer()
                Button("Cancel", action: importTask.cancel)
                    .foregroundColor(.red)
            }
            ProgressView(importTask.progress).font(.subheadline)
        }
        .onAppear { importTask.store(managedObjectContext: managedObjectContext) }
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView(importTask: Import(fileAt: URL(fileURLWithPath: "/null")))
    }
}
