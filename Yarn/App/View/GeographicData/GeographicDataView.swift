//
//  GeographicDataView.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI
import MapKit

struct GeographicDataView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(mapRect: .constant(.world))
                .edgesIgnoringSafeArea(.all)
            MapOptionsSelectionMenu()
        }
    }
}

struct MapOptionsSelectionMenu: View {
    var body: some View {
        Menu {
            Button("Paths") { }
            Button("Visited Areas") { }
        } label: {
            Label("Map options", systemImage: "point.topleft.down.curvedto.point.bottomright.up.fill")
        }
        .menuStyle(.button)
        .buttonStyle(.borderedProminent)
        .labelStyle(.iconOnly)
        .padding()
    }
}

struct GeographicDataView_Previews: PreviewProvider {
    static var previews: some View {
        GeographicDataView()
    }
}
