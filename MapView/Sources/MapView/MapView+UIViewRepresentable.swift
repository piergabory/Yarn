//
//  File.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import SwiftUI
import MapKit

#if os(iOS)

extension MapView: UIViewRepresentable {
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> MKMapView {
        makeMKMapView(context: mapContext(from: context))
    }

    public func updateUIView(_ mkMapView: MKMapView, context: UIViewRepresentableContext<Self>) {
        updateMKMapView(mkMapView, context: mapContext(from: context))
    }

    private func mapContext(from context: UIViewRepresentableContext<Self>) -> MapView.Context {
        MapView.Context(
            coordinator: context.coordinator,
            transaction: context.transaction,
            environment: context.environment
        )
    }
}

#endif
