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
        northEast = GeoQuadTree(region: region.subRegion(for: .northEast))
        northWest = GeoQuadTree(region: region.subRegion(for: .northWest))
        southEast = GeoQuadTree(region: region.subRegion(for: .southEast))
        southWest = GeoQuadTree(region: region.subRegion(for: .southWest))
        
        count = 0
        for element in elements {
            insert(element)
        }
        elements = []
    }
}
