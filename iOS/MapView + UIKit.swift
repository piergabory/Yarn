//
//  MapView + UIKit.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI
import MapKit

extension MapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        makeMKMapView(context: context)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateMKMapView(uiView, context: context)
    }
}
