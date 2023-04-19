//
//  BuildGeoRegions.swift
//  
//
//  Created by Pierre Gabory on 20/04/2023.
//

import CoreData
import Combine
import DataTransferObjects
import LocationDatabase
import QuadTrees
import Foundation
import CoreLocation

struct BuildGeoRegions: DataProcessorCommand {
    let logStream = PassthroughSubject<String, Never>()
    
    func execute(dbContext: NSManagedObjectContext) async throws {
        logStream.send("Starting building regions")
        let data = try await LocationDatumFetchRequest().execute(in: dbContext)
        logStream.send("Starting Building tree with \(data.count) data.")
        let tree = buildGeoTree(data: data)
        logStream.send("Finish tree, Breadth scanning...")
        let regions = breadthFirstScan(tree: tree)
        logStream.send("Saving nodes...")
        try await BatchGeoRegionInsertRequest(regions: regions).execute(in: dbContext)
        logStream.send("Done!")
    }
    
    private func buildGeoTree(data: [LocationDatum]) -> GeoDataTree {
        let tree = GeoDataTree()
        for datum in data {
            tree.insert(datum)
        }
        return tree
    }
    
    private func breadthFirstScan(tree: GeoDataTree) -> [GeoDataTree] {
        var stack = [tree]
        var nodes: [GeoDataTree] = []
        while let node = stack.popLast() {
            stack.append(contentsOf: node.childNodes)
            nodes.append(node)
        }
        return nodes
    }
    
    private func saveNodes(of tree: [GeoDataTree]) async throws {
        
    }
}
