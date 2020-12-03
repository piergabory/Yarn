//
//  MapView + AppKit.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI
import MapKit

extension MapView: NSViewRepresentable {
    
    func makeNSView(context: Context) -> MKMapView {
        makeMKMapView(context: context)
    }
    
    func updateNSView(_ nsView: MKMapView, context: Context) {
        updateMKMapView(nsView, context: context)
    }
}
