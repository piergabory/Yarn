//
//  PathView.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI

struct PathView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: false)])
    private var locations: FetchedResults<Location>
    
    var body: some View {
        MapView(path: locations.map(\.coordinate))
            .ignoresSafeArea()
    }
}

struct PathView_Previews: PreviewProvider {
    static var previews: some View {
        PathView()
    }
}
