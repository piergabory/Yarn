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
    
    private var occupiedBytes = 0
    private var bufferSize = 1024
    private var readBuffer: UnsafeMutablePointer<UInt8>!
    private var remainderBuffer: UnsafeMutablePointer<UInt8>!
    
    let subject = PassthroughSubject<Object, Error>()
    @Published var progress = 0
    
    init(stream: InputStream, shouldSkipToArrayBracket: Bool = true) {
        self.stream = stream
        self.shouldSkipToArrayBracket = shouldSkipToArrayBracket
    }
    
    func execute() -> AnyPublisher<Object, Error> {
        DispatchQueue.global(qos: .utility).async(execute: task)
        return subject.eraseToAnyPublisher()
    }
    
    private func swapBuffers() {
        (remainderBuffer, readBuffer) = (readBuffer, remainderBuffer)
    }
    
    private func task() {
        readBuffer = .allocate(capacity: bufferSize)
        remainderBuffer = .allocate(capacity: bufferSize)
        findBeginningOfArray()
        while stream.hasBytesAvailable {
            do {
                try decodeNextObject()
            } catch {
                subject.send(completion: .failure(error))
                return
            }
        }
        
        readBuffer.deallocate()
        remainderBuffer.deallocate()
        subject.send(completion: .finished)
    }
    
    private func findBeginningOfArray() {
        guard shouldSkipToArrayBracket, stream.hasBytesAvailable else { return }
        let skip = stream.read(readBuffer, maxLength: 256)
        progress += skip
        let data = Data(bytesNoCopy: readBuffer, count: skip, deallocator: .none)
        guard let bracketIndex = data.firstIndex(of: 0x5B) else {
            occupiedBytes = skip
            return
        }
        data[bracketIndex..<skip].copyBytes(to: remainderBuffer, count: skip - bracketIndex)
        swapBuffers()
    }

    private func decodeNextObject() throws {
        // Access bytes
        let headByteAddress = readBuffer + occupiedBytes
        let maxByteCount = bufferSize - occupiedBytes
        progress += stream.read(headByteAddress, maxLength: maxByteCount)
        
        // Decode data
        let data = Data(bytesNoCopy: readBuffer, count: bufferSize, deallocator: .none)
        guard let objectRange = rangeOfFirstObject(in: 0..<bufferSize) else { return }
        let object = try decoder.decode(Object.self, from: data[objectRange])
        
        // Publish
        subject.send(object)
        
        // Update state, swap buffers
        occupiedBytes = bufferSize - objectRange.last!
        data.copyBytes(to: remainderBuffer, from: objectRange.last!..<bufferSize)
        swapBuffers()
    }
    
    private func rangeOfFirstObject(in byteRange: Range<Int>) -> ClosedRange<Int>? {
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
        
        return nil
    }
    
    private func doubleBufferSize() {
        print("Doubling buffer size to \(bufferSize) bytes.")
        
        let biggerReadBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize * 2)
        let biggerRemainderBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize * 2)
        
        biggerReadBuffer.initialize(from: readBuffer, count: bufferSize)
        biggerRemainderBuffer.initialize(from: remainderBuffer, count: bufferSize)
        
        readBuffer.deallocate()
        remainderBuffer.deallocate()
        
        bufferSize *= 2
        
        readBuffer = biggerReadBuffer
        remainderBuffer = biggerRemainderBuffer
    }
}
