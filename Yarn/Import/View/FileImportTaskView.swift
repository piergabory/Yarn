//
//  FileImportTaskView.swift
//  Yarn
//
//  Created by Pierre Gabory on 04/04/2023.
//

import SwiftUI

struct FileImportTaskView: View {
    let task: Task<Void, Error>
    let progress: Progress
    @State var caughtError: Error?
    
    var body: some View {
        HStack {
            ProgressView(progress)
            if task.isCancelled {
                Text("Cancelled")
            } else {
                Button("Stop", action: task.cancel)
                    .foregroundColor(.red)
            }
            if let caughtError {
                Text(caughtError.localizedDescription)
            }
        } .task {
            do {
                try await task.value
            } catch {
                caughtError = error
            }
        }
    }
}


struct FileImportTaskView_Previews: PreviewProvider {
    static var previews: some View {
        FileImportTaskView(
            task: .detached {},
            progress: Progress(totalUnitCount: 100)
        )
        .previewLayout(.sizeThatFits)
    }
}
