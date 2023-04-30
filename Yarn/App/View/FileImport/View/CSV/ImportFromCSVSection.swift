//
//  ImportFromCSVSection.swift
//  Yarn
//
//  Created by Pierre Gabory on 30/04/2023.
//

import SwiftUI

struct ImportFromCSVSection: View {
    let onFileSelect: () -> Void
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Import from CSV file")
                    .font(.headline)
                Text("Import data from comma separated values containing at least 3 column for latitude, longitude and timeStamp or iso8601 date.")
                    .foregroundColor(.secondary)
            }
            ImportFromCSVConfigurationView()
                .padding(.leading)
            FilePickerButton(
                label: "Open CSV file",
                systemImage: "doc",
                allowedContentTypes: [.commaSeparatedText]
            ) { result in
                onFileSelect()
            }
        }
    }
}

struct ImportFromCSVSection_Previews: PreviewProvider {
    static var previews: some View {
        ImportFromCSVSection(onFileSelect: { })
    }
}
