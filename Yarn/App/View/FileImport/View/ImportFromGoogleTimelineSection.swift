//
//  ImportFromGoogleTimelineSection.swift
//  Yarn
//
//  Created by Pierre Gabory on 30/04/2023.
//

import SwiftUI

struct ImportFromGoogleTimelineSection: View {
    let onFileSelect: () -> Void
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Import from Google Timeline")
                    .font(.headline)
                Text("Go to google.com/takeout and download your location data.\nIn the zip file, find the \"Record.json\" file and open it in the app.")
                    .foregroundColor(.secondary)
            }
            Link(destination: URL(string: "https://google.com/takeout")!) {
                Label("Go to Google Takout", systemImage: "safari")
                    .foregroundColor(.primary)
            }
            FilePickerButton(
                label: "Open JSON file",
                systemImage: "doc",
                allowedContentTypes: [.json]
            ) { result in
                onFileSelect()
            }
        }
    }
}
struct ImportFromGoogleTimelineSection_Previews: PreviewProvider {
    static var previews: some View {
        ImportFromGoogleTimelineSection(onFileSelect: { })
    }
}
