//
//  SwiftMKMapView.swift
//  
//
//  Created by Pierre Gabory on 08/04/2023.
//

import MapKit
import SwiftUI

public struct MapView {
    public struct Coordinator {
        let delegate = MapViewDelegate()
    }
    
    struct Context {
        let coordinator: Coordinator
        let transaction: Transaction
        let environment: EnvironmentValues
    }
    
    public init() {
        // Nothing to do
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeMKMapView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator.delegate
        configure(mkMapView, environment: context.environment)
        return mkMapView
    }
    
    func updateMKMapView(_ mkMapView: MKMapView, context: Context) {
        mkMapView.delegate = context.coordinator.delegate
        configure(mkMapView, environment: context.environment)
    }
    
    private func configure(_ mkMapView: MKMapView, environment: EnvironmentValues) {
        mkMapView.mapType = environment.mapType
        
        mkMapView.removeOverlays(mkMapView.overlays)
        if environment.aboveRoadsOverlays.isEmpty == false {
            mkMapView.addOverlays(environment.aboveRoadsOverlays, level: .aboveRoads)
        }
        if environment.aboveLabelsOverlays.isEmpty == false {
            mkMapView.addOverlays(environment.aboveLabelsOverlays, level: .aboveLabels)
        }
    }
}
