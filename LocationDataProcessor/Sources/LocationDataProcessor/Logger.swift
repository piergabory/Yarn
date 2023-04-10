//
//  File.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import Combine
import Foundation

public final class Logger {
    public private(set) var history = ""
    private var connectedStreams = Set<AnyCancellable>()
    
    func connect(_ stream: AnyPublisher<String, Never>) {
        stream
            .sink { [weak self] message in
                self?.send(message: message)
            }
            .store(in: &connectedStreams)
    }
    
    func send(message: String) {
        print(message)
        history += message + "\n"
    }
}
