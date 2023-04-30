//
//  ProcessingTasksSection.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI

struct ProcessingTasksSection: View {
    
    @EnvironmentObject
    var queue: ProcessingTaskQueue
    
    var body: some View {
        Section {
            ForEach(queue.tasks) { task in
                ProcessingTaskView(task: task)
            }
        } header: {
            Label(
                "In progress, please keep the app open.",
                systemImage: "exclamationmark.triangle.fill"
            )
        }
    }
}

struct ProcessingTasksSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ProcessingTasksSection()
                .environmentObject(ProcessingTaskQueue())
        }
    }
}
