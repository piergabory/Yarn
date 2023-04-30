//
//  FilePickerButton.swift
//  Yarn
//
//  Created by Pierre Gabory on 30/04/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePickerButton: View {
    @State
    var isFilePickerPresented = false
    
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

struct FilePickerButton_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerButton(
            label: "File picker button label",
            systemImage: "star",
            allowedContentTypes: [.json],
            onCompletion: { _ in })
    }
}
