//
//  JSONStreamDeserializer.swift
//  
//
//  Created by Pierre Gabory on 28/03/2023.
//

import Foundation

public protocol JSONObjectDeserializer {
    associatedtype Item
    func deserialize(_: NSDictionary) throws -> Item
}

public struct JSONStreamDeserializer<Deserializer: JSONObjectDeserializer> {
    enum Error: Swift.Error {
        case couldntReachArray(stopAtPathKey: String)
        case pathDidntLeadToArrayType
        case listItemIsNotObject
    }
        
    /// Property keys leading to the iterated array.
    let arrayPropertyPath: [String]
    let itemDeserializer: Deserializer
    
    func deserialize(jsonStream: InputStream) throws -> AsyncStream<Deserializer.Item> {
        let rootObject = try JSONSerialization.jsonObject(with: jsonStream)
        let array = try findArray(in: rootObject)
        
        return AsyncStream { continuation in
            for item in array {
                do {
                    guard let jsonObject = item as? NSDictionary else { throw Error.listItemIsNotObject }
                    let item = try itemDeserializer.deserialize(jsonObject)
                    continuation.yield(item)
                } catch {
                    print(error)
                }
            }
            continuation.finish()
        }
    }

    private func findArray(in object: Any?) throws -> NSArray {
        var object = object
    
        for key in arrayPropertyPath {
            if let parent = object as? NSDictionary {
                object = parent[key]
            } else {
                throw Error.couldntReachArray(stopAtPathKey: key)
            }
        }

        if let result = object as? NSArray {
            return result
        } else {
            throw Error.pathDidntLeadToArrayType
        }
    }
}
