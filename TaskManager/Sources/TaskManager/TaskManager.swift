//
//  TaskManager.swift
//
//
//  Created by Pierre Gabory on 20/05/2023.
//

import SwiftUI

public class TaskManager: ObservableObject {
    @Published var tasks: [any ManagedTask] = []
    
    func track(task: some ManagedTask) {
        tasks.append(task)
    }
}
