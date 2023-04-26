//
//  ProcessingTaskQueue.swift
//  Yarn
//
//  Created by Pierre Gabory on 26/04/2023.
//

import Combine
import Foundation

final class ProcessingTaskQueue: ObservableObject {
    @Published var tasks: [ProcessingTask] = []
}
