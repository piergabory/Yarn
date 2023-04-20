//
//  MKMapViewRepresentable.swift
//  
//
//  Created by Pierre Gabory on 08/04/2023.
//

import MapKit
import SwiftUI

public struct MKMapViewRepresentable: UIViewRepresentable {
    
    public class Coordinator: NSObject {
        let representable: MKMapViewRepresentable
        
        init(representable: MKMapViewRepresentable) {
            self.representable = representable
        }
    }
    
    @Binding public var region: MKCoordinateRegion
    
    public init(region: Binding<MKCoordinateRegion>) {
        self._region = region
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(representable: self)
    }

    public func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator
        mkMapView.region = region
        return mkMapView
    }
    
    public func updateUIView(_ mkMapView: MKMapView, context: Context) {
        mkMapView.delegate = context.coordinator
        mkMapView.region = region
    }
}
