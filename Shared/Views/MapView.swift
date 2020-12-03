//
//  MapView.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import Foundation
import MapKit

struct MapView {
    func makeMKMapView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .mutedStandard
        return mapView
    }
    
    func updateMKMapView(_ mkMapView: MKMapView, context: Context) {
        
    }
    
    func makeCoordinator() -> MapDelegate {
        MapDelegate(parent: self)
    }
}


class MapDelegate: NSObject, MKMapViewDelegate {
    let parent: MapView
    
    init(parent: MapView) {
        self.parent = parent
    }
    
    
}
