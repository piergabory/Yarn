//
//  ProcessingTask.swift
//  
//
//  Created by Pierre Gabory on 23/04/2023.
//

import Combine
import Foundation

public struct ProcessingTask: Identifiable {
    public typealias LogStream = AnyPublisher<String, Never>
    
    public let id: UUID
    public let label: String
    public let logs: LogStream
    public let task: Task<Void, Error>
    public let progess: Progress
    
    public init(
        id: UUID,
        label: String,
        logs: LogStream,
        task: Task<Void, Error>, 
        progess: Progress
    ) {
        self.id = id
        self.label = label
        self.logs = logs
        self.task = task
        self.progess = progess
    }
}
