//
//  FileImportView.swift
//  Yarn
//
//  Created by Pierre Gabory on 31/03/2023.
//

import SwiftUI
import FileImportService
import UniformTypeIdentifiers

struct FileImportView: View {
    struct ImportTask: Identifiable {
        let id = UUID()
        let progress: Progress
        let task: Task<Void, Error>
    }
    @State private var isFileImporterPresented = false
    @State private var importTasks: [ImportTask] = []
    
    var body: some View {
        List(importTasks) { importTask in
            FileImportTaskView(
                task: importTask.task,
                progress: importTask.progress
            )
        }
        .toolbar {
            Button("Select File") { isFileImporterPresented = true }
        }
        .fileImporter(
            isPresented: $isFileImporterPresented,
            allowedContentTypes: [.json],
            onCompletion: handleFileImporter
        )
    }
    
    private func handleFileImporter(result: Result<URL, Error>) {
        do {
            let url = try result.get()
            isFileImporterPresented = false
            try loadFile(fileURL: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadFile(fileURL: URL) throws {
        let deserializer = GoogleTimelineDeserializer()
        let importService = try JSONLocationFileImportService(fileURL: fileURL, fileDeserializer: deserializer)
        let task = ImportTask(
            progress: importService.progress,
            task: .detached { try await importService.load() }
        )
        importTasks.append(task)
    }
}

struct FileImportView_Previews: PreviewProvider {
    static var previews: some View {
        FileImportView()
    }
}
