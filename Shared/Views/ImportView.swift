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
            Text("Importing...")
            .font(.headline)
            Divider()
            HStack {
                Text(importTask.fileName)
                Spacer()
                Button("Cancel", action: importTask.cancel)
                    .foregroundColor(.red)
            }
            .padding(.vertical)
            ProgressView(importTask.progress)
                .font(.subheadline)
        }
        .onAppear { importTask.store(managedObjectContext: managedObjectContext) }
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView(importTask: Import(fileAt: URL(fileURLWithPath: "/null")))
            .previewLayout(.sizeThatFits)
    }
}
