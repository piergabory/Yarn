//
//  ManagedTask.swift
//  
//
//  Created by Pierre Gabory on 20/05/2023.
//

import Combine
import Foundation

protocol ManagedTask {
    var id: UUID { get }
    var label: String { get }
    var logStream: AnyPublisher<String, Never> { get }
    var progress: Progress { get }
    
    func cancel() -> Void
}
