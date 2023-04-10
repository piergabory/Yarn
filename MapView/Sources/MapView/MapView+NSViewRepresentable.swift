//
//  File.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import SwiftUI
import MapKit

#if os(macOS)

extension MapView: NSViewRepresentable {
    public func makeNSView(context: NSViewRepresentableContext<Self>) -> MKMapView {
        makeMKMapView(context: mapContext(from: context))
    }
    
    public func updateNSView(_ mkMapView: MKMapView, context: NSViewRepresentableContext<Self>) {
        updateMKMapView(mkMapView, context: mapContext(from: context))
    }
    
    private func mapContext(from context: NSViewRepresentableContext<Self>) -> MapView.Context {
        MapView.Context(
            coordinator: context.coordinator,
            transaction: context.transaction,
            environment: context.environment
        )
    }
}

#endif
