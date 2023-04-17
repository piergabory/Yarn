//
//  File.swift
//  
//
//  Created by Pierre Gabory on 18/04/2023.
//

import Foundation

extension GeoQuadTree {

    func leafNodes(upToLevel maxLevel: Int) -> [GeoQuadTree] {
        var depth = 1
        var stack = [self]
        var selection: [GeoQuadTree] = []
        while let node = stack.popLast() {
            if depth > maxLevel {
                continue
            }
            if node.childNodes.isEmpty {
                selection.append(node)
                depth -= 1
            } else {
                stack += node.childNodes
                depth += 1
            }
        }
        return selection
    }
    
    func fetch(_ queryRegion: RectangularRegion) -> [Element] {
        var stack = [self]
        var results: [Element] = []
        while let node = stack.popLast() {
            guard node.region.intersect(region: queryRegion) else { continue }
            stack += node.childNodes
            results += node.elements
        }
        return results.filter {
            queryRegion.contains(coordinate: $0.geolocation)
        }
    }
}
