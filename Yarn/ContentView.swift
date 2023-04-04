//
//  ContentView.swift
//  Yarn
//
//  Created by Pierre Gabory on 31/03/2023.
//

import SwiftUI
import FileImportService
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State private var isFileImporterPresented = false
    @State private var caughtError: Error?
    @State private var progress: Progress?
    @State private var importTask: Task<Void, Never>?
    
    var body: some View {
        VStack {
            Button("Select File") { isFileImporterPresented = true }
                .buttonStyle(.bordered)
                .fileImporter(
                    isPresented: $isFileImporterPresented,
                    allowedContentTypes: [.json],
                    onCompletion: handleFileImporter
                )
            if let progress {
                ProgressView(progress)
            }
            if let importTask {
                Button("Stop", action: importTask.cancel)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.red)
            }
            if let caughtError {
                Label(caughtError.localizedDescription, image: "exclamationmark.triangle.fill")
            }
        }
        .padding()
    }
    
    private func handleFileImporter(result: Result<URL, Error>) {
        importTask = Task {
            do {
                let url = try result.get()
                isFileImporterPresented = false
                try await loadFile(fileURL: url)
            } catch {
                print(error.localizedDescription)
                caughtError = error
            }
        }
    }
    
    private func loadFile(fileURL: URL) async throws {
        let deserializer = GoogleTimelineDeserializer()
        let importService = try JSONLocationFileImportService(fileURL: fileURL, fileDeserializer: deserializer)
        progress = importService.progress
        try await importService.load()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
