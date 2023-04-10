//
//  SwiftUIView.swift
//  
//
//  Created by Pierre Gabory on 08/04/2023.
//

import MapKit
import SwiftUI

public struct PathView: UIViewRepresentable {
    public struct Coordinator {
        let delegate = PathMapViewDelegate()
    }
    
    private let delegate = PathMapViewDelegate()
    private let paths: [[CLLocationCoordinate2D]]
    
    public init(paths: [[CLLocationCoordinate2D]]) {
        self.paths = paths
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.preferredConfiguration = MKStandardMapConfiguration(
            elevationStyle: .realistic,
            emphasisStyle: .muted
        )
        mkMapView.delegate = context.coordinator.delegate
        updateOverlays(mkMapView)
        return mkMapView
    }
    
    public func updateUIView(_ mkMapView: MKMapView, context: Context) {
        mkMapView.delegate = context.coordinator.delegate
        mkMapView.removeOverlays(mkMapView.overlays)
        updateOverlays(mkMapView)
    }
    
    private func updateOverlays(_ mkMapView: MKMapView) {
        if let overlay = buildPathOverlays() {
            mkMapView.addOverlay(overlay, level: .aboveRoads)
        }
        if let overlay = buildConnectionsOverlays() {
            mkMapView.addOverlay(overlay, level: .aboveRoads)
        }
    }
    
    private func buildConnectionsOverlays() -> MKOverlay? {
        guard paths.count > 2 else { return nil }
        var polylines: [MKPolyline] = []
        var start: CLLocationCoordinate2D?
        for path in paths {
            if let start, let end = path.first {
                let coordinates = [start, end]
                polylines.append(MKGeodesicPolyline(coordinates: coordinates, count: 2))
            }
            start = path.last
        }
        let multiPolyline = MKMultiPolyline(polylines)
        multiPolyline.title = "Connections"
        return multiPolyline
    }
    
    private func buildPathOverlays() -> MKOverlay? {
        guard paths.isEmpty == false else { return nil }
        var polylines: [MKPolyline] = []
        for path in paths where path.isEmpty == false {
            let line = MKGeodesicPolyline(coordinates: path, count: path.count)
            polylines.append(line)
        }
        let multiPolyline = MKMultiPolyline(polylines)
        multiPolyline.title = "Paths"
        return multiPolyline
    }
}

class PathMapViewDelegate: NSObject, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let multiPolyline as MKMultiPolyline where multiPolyline.title == "Connections" :
            let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
            renderer.strokeColor = .orange
            renderer.lineDashPattern = [3, 10]
            renderer.lineWidth = 1
            return renderer
        case let multiPolyline as MKMultiPolyline where multiPolyline.title == "Paths":
            let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
            renderer.strokeColor = .red
            renderer.lineWidth = 3
            return renderer
        case let polyline as MKPolyline where polyline.pointCount == 2:
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .orange
            renderer.lineDashPattern = [3, 10]
            renderer.lineWidth = 1
            return renderer
        case let polyline as MKPolyline:
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .red
            renderer.lineWidth = 3
            return renderer
        default:
            return MKOverlayRenderer()
        }
    }
}
