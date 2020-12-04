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

struct JSONStreamDecoder<Object: Decodable> {
    typealias Result = (Object, Int)
    
    private let decoder = JSONDecoder()
    private let subject = PassthroughSubject<Result, Error>()
    private let bufferSize = 100000
    private let targetQueue = DispatchQueue.global(qos: .utility)
    
    func decode(stream: InputStream) -> AnyPublisher<Result, Error>  {
        targetQueue.async { [self] in
            do { try decodingTask(stream: stream, skipBytes: 10) }
            catch { subject.send(completion: .failure(error)) }
        }
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Private
        
    private func decodingTask(stream: InputStream, skipBytes: Int = 0) throws {
        // Initialize Buffers
        var occupiedBytes = 0
        var readBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        var remainderBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
        // Advance past the root object
        stream.read(readBuffer, maxLength: skipBytes)
        
        // Decode File
        while (stream.hasBytesAvailable) {
            
            // Access bytes
            let headByteAddress = readBuffer + occupiedBytes
            let maxByteCount = bufferSize - occupiedBytes
            let bytesReadCount = stream.read(headByteAddress, maxLength: maxByteCount)
            
            // Decode data
            let data = Data(bytesNoCopy: readBuffer, count: bufferSize, deallocator: .none)
            let objectRange = try rangeOfFirstObject(in: readBuffer, count: bufferSize)
            let object = try decoder.decode(Object.self, from: data[objectRange])
            
            // Publish
            subject.send((object, bytesReadCount))
            
            // Update state, swap buffers
            occupiedBytes = bufferSize - objectRange.last!
            data.copyBytes(to: remainderBuffer, from: objectRange.last!..<bufferSize)
            (remainderBuffer, readBuffer) = (readBuffer, remainderBuffer)
        }
        
        // Deallocate Buffers
        readBuffer.deallocate()
        remainderBuffer.deallocate()
        subject.send(completion: .finished)
    }
    
    /// Returns byte range of the first complete object in the data
    /// O(n)
    private func rangeOfFirstObject(in jsonData: UnsafePointer<UInt8>, count: Int) throws -> ClosedRange<Int> {
        var start: Int? = nil
        var depth = 0
        
        for index in 0..<count {
            switch (jsonData + index).pointee {
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
        
        // Error
        let data = Data(bytes: jsonData, count: count)
        let string = String(data: data, encoding: .utf8)
        throw JSONStreamDecodingError.failedToFindNextObject(jsonString: string ?? "[Non UTF8 Data]")
    }
}

