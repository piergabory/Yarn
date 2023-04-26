//
//  ProcessingTaskView.swift
//  Yarn
//
//  Created by Pierre Gabory on 26/04/2023.
//

import Combine
import SwiftUI

struct ProcessingTaskView: View {
    @State private var lastMessage = "Processing..."
    let task: ProcessingTask
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(task.label)
                .font(.headline)
            Text(lastMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
            ProgressView(task.progess)
                .progressViewStyle(.linear)
        }
        .onReceive(task.logs) { message in
            lastMessage = message
        }
    }
}

struct ProcessingTaskView_Previews: PreviewProvider {
    static let task = ProcessingTask(
        id: UUID(),
        label: "Title",
        logs: Just("Some message").eraseToAnyPublisher(),
        task: Task.detached { },
        progess: Progress(totalUnitCount: 100)
    )
    
    static var previews: some View {
        List {
            ProcessingTaskView(task: task)
        }
    }
}
