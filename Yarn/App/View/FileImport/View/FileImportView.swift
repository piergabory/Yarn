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
                ImportFromGoogleTimelineSection(onFileSelect: onDismiss)
                ImportFromCSVSection(onFileSelect: onDismiss)
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

struct FileImportView_Previews: PreviewProvider {
    static var previews: some View {
        FileImportView { }
    }
}
