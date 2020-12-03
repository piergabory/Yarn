//
//  MapView.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import Foundation
import MapKit
import SwiftUI

struct MapView {
    let path: [CLLocationCoordinate2D]
    
    func makeMKMapView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .mutedStandard
        updateMKMapView(mapView, context: context)
        return mapView
    }
    
    func updateMKMapView(_ mkMapView: MKMapView, context: Context) {
        updatePathOverlay(of: mkMapView)
    }
    
    func makeCoordinator() -> MapDelegate {
        MapDelegate(parent: self)
    }
    
    // MARK: - Private
    
    private func updatePathOverlay(of mkMapView: MKMapView) {
        mkMapView.removeOverlays(mkMapView.overlays)
        if path.isEmpty { return }
        let overlay = MKGeodesicPolyline(coordinates: path, count: path.count)
        mkMapView.addOverlay(overlay)
    }
}


class MapDelegate: NSObject, MKMapViewDelegate {
    let parent: MapView
    
    init(parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 1
        renderer.strokeColor = .systemBlue
        return renderer
    }
}
