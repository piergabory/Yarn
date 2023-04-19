//
//  File.swift
//  
//
//  Created by Pierre Gabory on 18/04/2023.
//

import Foundation

extension GeoQuadTree {
    public func insert(_ element: Element) {
        var node = self
        while let childNode = node.childNode(containing: element) {
            node = childNode
            node.count += 1
        }
        node.elements.append(element)
        if node.elements.count > node.capacity {
            node.subdivide()
        }
    }
    
    private func childNode(containing element: Element) -> GeoQuadTree? {
        for childNode in childNodes {
            if childNode.region.contains(coordinate: element.geolocation) == true {
                return childNode
            }
        }
        return nil
    }
    
    private func subdivide() {
        var geoHash = self.geoHash
        var digit: UInt32 = 0
        if level % 10 != 0 {
            let lastDigit = geoHash.popLast() ?? 0
            digit = lastDigit << 2
        }
        
        northEast = GeoQuadTree(
            region: region.subRegion(for: .northEast),
            level: level + 1,
            geoHash: geoHash + [digit + 0]
        )
        northWest = GeoQuadTree(
            region: region.subRegion(for: .northWest),
            level: level + 1,
            geoHash: geoHash + [digit + 1]
        )
        southEast = GeoQuadTree(
            region: region.subRegion(for: .southEast),
            level: level + 1,
            geoHash: geoHash + [digit + 2]
        )
        southWest = GeoQuadTree(
            region: region.subRegion(for: .southWest),
            level: level + 1,
            geoHash: geoHash + [digit + 3]
        )
        
        count = 0
        for element in elements {
            insert(element)
        }
        elements = []
    }
}
