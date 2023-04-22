//
//  FileImportView.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileImportView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                ImportFromGoogleTimelineSection()
                ImportFromCSVSection()
                AutomaticTrackingSettingsSection()
            }
            .navigationTitle("File Import")
            .toolbar {
                Button(action: onDismiss) {
                    Label("Exit", systemImage: "xmark")
                }
            }
        }
    }
}

struct ImportFromGoogleTimelineSection: View {
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
            }
        }
    }
}

struct ImportFromCSVSection: View {
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
            }
        }
    }
}

struct ImportFromCSVConfigurationView: View {
    enum DateFormatStyle: CaseIterable, Identifiable {
        case timestamp, iso8601
        var id: Self { self }
    }
    
    @State var latitudeColumnIndex: Int = 0
    @State var longitudeColumnIndex: Int = 1
    @State var dateColumnIndex: Int = 2
    @State var dateStyle: DateFormatStyle = .timestamp

    var body: some View {
        VStack {
            Stepper(value: $latitudeColumnIndex, in: 0...100) {
                Text("Latitude column: \(latitudeColumnIndex)")
            }
            Stepper(value: $longitudeColumnIndex, in: 0...100) {
                Text("Longitude column: \(longitudeColumnIndex)")
            }
            Stepper(value: $dateColumnIndex, in: 0...100) {
                Text("Date column: \(dateColumnIndex)")
            }
            Picker("Date format style: ", selection: $dateStyle) {
                Text("ISO 8601").tag(DateFormatStyle.iso8601)
                Text("Timestamp").tag(DateFormatStyle.timestamp)
            }
        }

    }
}

struct FilePickerButton: View {
    @State var isFilePickerPresented = false
    
    let label: String
    let systemImage: String
    let allowedContentTypes: [UTType]
    let onCompletion: (Result<URL, Error>) -> Void
    
    var body: some View {
        Button {
            isFilePickerPresented = true
        } label: {
            Label(label, systemImage: systemImage)
        }
        .fileImporter(
            isPresented: $isFilePickerPresented,
            allowedContentTypes: allowedContentTypes,
            onCompletion: onCompletion
        )
    }
}

struct FileImportView_Previews: PreviewProvider {
    static var previews: some View {
        FileImportView { }
    }
}
