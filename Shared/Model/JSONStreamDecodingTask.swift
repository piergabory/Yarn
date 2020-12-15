//
//  StreamDecoder.swift
//  Yarn
//
//  Created by Pierre Gabory on 04/12/2020.
//

import Foundation
import Combine

enum JSONStreamDecodingError: Error {
    case failedToFindNextObject(jsonString: String)
}

class JSONStreamDecodingTask<Object: Decodable> {
    
    private let decoder = JSONDecoder()
    private let stream: InputStream
    private let shouldSkipToArrayBracket: Bool
    private var isCancelled = false
    
    // MARK: Buffers
    
    private var occupiedBytes = 0
    private var bufferSize = 1024
    private var readBuffer: UnsafeMutablePointer<UInt8>!
    private var remainderBuffer: UnsafeMutablePointer<UInt8>!
    
    // MARK: Publishers
    
    private let subject = PassthroughSubject<Object, Error>()
    @Published var progress = 0
    
    
    // MARK: - Public
    
    init(stream: InputStream, shouldSkipToArrayBracket: Bool = true) {
        self.stream = stream
        self.shouldSkipToArrayBracket = shouldSkipToArrayBracket
    }
    
    func execute() -> AnyPublisher<Object, Error> {
        DispatchQueue.global(qos: .utility).async(execute: task)
        return subject
            .handleEvents(receiveCancel: { self.isCancelled = true })
            .share()
            .eraseToAnyPublisher()
    }
    
    // MARK: - Decoding Task
    
    private func task() {
        readBuffer = .allocate(capacity: bufferSize)
        remainderBuffer = .allocate(capacity: bufferSize)
        findBeginningOfArray()
        while stream.hasBytesAvailable {
            do {
                try decodeNextObject()
            } catch {
                subject.send(completion: .failure(error))
                break
            }
        }
        readBuffer.deallocate()
        remainderBuffer.deallocate()
        subject.send(completion: .finished)
    }
    
    private func decodeNextObject() throws {
        fillReadBuffer()
        
        // Decode data
        let objectRange = try rangeOfFirstObject(in: 0..<bufferSize)
        let data = Data(bytesNoCopy: readBuffer, count: bufferSize, deallocator: .none)
        let object = try decoder.decode(Object.self, from: data[objectRange])
        
        // Publish
        subject.send(object)
        
        // Update state, swap buffers
        occupiedBytes = bufferSize - objectRange.last!
        data.copyBytes(to: remainderBuffer, from: objectRange.last!..<bufferSize)
        swapBuffers()
    }
    
    private func findBeginningOfArray() {
        guard shouldSkipToArrayBracket, stream.hasBytesAvailable else { return }
        let skip = stream.read(readBuffer, maxLength: bufferSize)
        progress += skip
        let data = Data(bytesNoCopy: readBuffer, count: skip, deallocator: .none)
        let jsonArrayFirstByteIndex = data.firstIndex(of: 0x5B) ?? 0
        occupiedBytes = skip - jsonArrayFirstByteIndex
        if jsonArrayFirstByteIndex > 0 {
            let remainder = data[jsonArrayFirstByteIndex..<skip]
            remainder.copyBytes(to: remainderBuffer, count: skip - jsonArrayFirstByteIndex)
            swapBuffers()
        }
    }
    
    private func rangeOfFirstObject(in byteRange: Range<Int>) throws -> ClosedRange<Int> {
        var start: Int? = nil
        var depth = 0
        var byteRange = byteRange
        repeat {
            for index in byteRange {
                switch (readBuffer + index).pointee {
                case 0x7b:
                    depth += 1
                    if start == nil { start = index}
                case 0x7d:
                    if start == nil { break }
                    depth -= 1
                    if depth == 0 { return start!...index }
                default: break
                }
            }
            doubleBufferSize()
            byteRange = byteRange.upperBound..<bufferSize
        } while(stream.hasBytesAvailable)
        
        // Throw error
        let data = Data(bytesNoCopy: readBuffer, count: byteRange.last!, deallocator: .none)
        let string = String.init(data:  data[byteRange], encoding: .utf8)!
        throw JSONStreamDecodingError.failedToFindNextObject(jsonString: string)
    }
    
    
    // MARK: - Buffer Operations
    
    private func fillReadBuffer() {
        let headByteAddress = readBuffer + occupiedBytes
        let maxByteCount = bufferSize - occupiedBytes
        let readBytes = stream.read(headByteAddress, maxLength: maxByteCount)
        occupiedBytes += readBytes
        progress += readBytes
    }
    
    private func swapBuffers() {
        (remainderBuffer, readBuffer) = (readBuffer, remainderBuffer)
    }

    private func doubleBufferSize() {
        let biggerReadBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize * 2)
        let biggerRemainderBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize * 2)
        
        biggerReadBuffer.initialize(from: readBuffer, count: bufferSize)
        biggerRemainderBuffer.initialize(from: remainderBuffer, count: bufferSize)
        
        readBuffer.deallocate()
        remainderBuffer.deallocate()
        
        bufferSize *= 2
        print("Doubled buffer size to \(bufferSize) bytes.")
        
        readBuffer = biggerReadBuffer
        remainderBuffer = biggerRemainderBuffer
        
        fillReadBuffer()
    }
}
