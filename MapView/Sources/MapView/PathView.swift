//
//  SwiftUIView.swift
//  
//
//  Created by Pierre Gabory on 08/04/2023.
//

import MapKit
import SwiftUI

public struct PathView: UIViewRepresentable {
    private let delegate = PathMapViewDelegate()
    private let path: [CLLocationCoordinate2D]
    
    public init(path: [CLLocationCoordinate2D]) {
        self.path = path
    }

    public func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.preferredConfiguration = MKStandardMapConfiguration(
            elevationStyle: .realistic,
            emphasisStyle: .muted
        )
        mkMapView.delegate = delegate
        if path.isEmpty == false {
            let overlay = MKGeodesicPolyline(coordinates: path, count: path.count)
            mkMapView.addOverlay(overlay, level: .aboveRoads)
        }
        return mkMapView
    }

    public func updateUIView(_ mkMapView: MKMapView, context: Context) {
        if path.isEmpty == false {
            let overlay = MKGeodesicPolyline(coordinates: path, count: path.count)
            mkMapView.addOverlay(overlay, level: .aboveRoads)
        }
    }
}

private class PathMapViewDelegate: NSObject, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let polylineRenderer as MKPolyline:
            let renderer = MKPolylineRenderer(polyline: polylineRenderer)
            renderer.strokeColor = .red
            renderer.lineWidth = 3
            return renderer
        default:
            return MKOverlayRenderer()
        }
    }
}
