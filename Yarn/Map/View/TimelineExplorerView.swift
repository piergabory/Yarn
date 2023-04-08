//
//  TimelineExplorerView.swift
//  Yarn
//
//  Created by Pierre Gabory on 08/04/2023.
//

import LocationDatabase
import CoreLocation
import MapView
import SwiftUI

struct TimelineExplorerView: View {
    @Environment(\.managedObjectContext) var dbContext
    @State var path: [CLLocationCoordinate2D] = []
    
    var body: some View {
        PathView(path: path)
            .task {
                do {
                    let dateInterval = DateInterval(start: .now - 2300000, end: .now)
                    let response = try await CLLocationCoordinate2DFetchRequest()
                        .filter(dateInterval: dateInterval)
                        .execute(in: dbContext)
                    print("Path with \(response.count) points.")
                    path = response
                } catch {
                    print(error)
                }
            }
    }
}

struct TimelineExplorerView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineExplorerView()
    }
}
