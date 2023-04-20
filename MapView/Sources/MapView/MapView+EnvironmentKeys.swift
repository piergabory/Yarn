//
//  File.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import MapKit
import SwiftUI

struct MKMapViewRepresentableOverlays {
    let aboveRoads: [MKOverlay]
    let aboveLabels: [MKOverlay]
}

private struct MKMapViewRepresentableOverlaysKey: EnvironmentKey {
    static let defaultValue = MKMapViewRepresentableOverlays(aboveRoads: [], aboveLabels: [])
}

private struct MKMapViewRepresentableMapTypeKey: EnvironmentKey {
    static public var defaultValue: MKMapType = .standard
}

extension EnvironmentValues {
    var mkMapViewOverlays: MKMapViewRepresentableOverlays {
        get { self[MKMapViewRepresentableOverlaysKey.self] }
        set { self[MKMapViewRepresentableOverlaysKey.self] = newValue }
    }
    
    var mkMapViewMapType: MKMapType {
        get { self[MKMapViewRepresentableMapTypeKey.self] }
        set { self[MKMapViewRepresentableMapTypeKey.self] = newValue }
    }
}

public extension View {
    
    func mapOverlay(aboveRoads: [MKOverlay] = [], aboveLabels: [MKOverlay] = []) -> some View {
        environment(\.mkMapViewOverlays, MKMapViewRepresentableOverlays(
            aboveRoads: aboveRoads,
            aboveLabels: aboveLabels
        ))
    }
    func mapType(_ mapType: MKMapType) -> some View {
        environment(\.mkMapViewMapType, mapType)
    }
}
