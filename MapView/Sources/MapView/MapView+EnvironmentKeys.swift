//
//  File.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import MapKit
import SwiftUI

private struct AboveRoadsOverlaysEnvironmentKey: EnvironmentKey {
    static let defaultValue: [MKOverlay] = []
}

private struct AboveLabelsOverlaysEnvironmentKey: EnvironmentKey {
    static let defaultValue: [MKOverlay] = []
}

extension MKMapType: EnvironmentKey {
    static public var defaultValue: MKMapType = .standard
}

extension EnvironmentValues {
    var aboveRoadsOverlays: [MKOverlay] {
        get { self[AboveRoadsOverlaysEnvironmentKey.self] }
        set { self[AboveRoadsOverlaysEnvironmentKey.self] = newValue }
    }
    
    var aboveLabelsOverlays: [MKOverlay] {
        get { self[AboveLabelsOverlaysEnvironmentKey.self] }
        set { self[AboveLabelsOverlaysEnvironmentKey.self] = newValue }
    }
    
    var mapType: MKMapType {
        get { self[MKMapType.self] }
        set { self[MKMapType.self] = newValue }
    }
}

public extension View {
    
    func overlay(_ overlay: MKOverlay?, level: MKOverlayLevel) -> some View {
        if let overlay {
            return overlays([overlay], level: level)
        } else {
            return overlays([], level: level)
        }
    }

    func overlays(_ overlays: [MKOverlay], level: MKOverlayLevel) -> some View {
        switch level {
        case .aboveRoads:
            return environment(\.aboveRoadsOverlays, overlays)
        case .aboveLabels:
            return environment(\.aboveLabelsOverlays, overlays)
        @unknown default:
            return environment(\.aboveLabelsOverlays, overlays)
        }
    }
    
    func mapType(_ mapType: MKMapType) -> some View {
        environment(\.mapType, mapType)
    }
}
