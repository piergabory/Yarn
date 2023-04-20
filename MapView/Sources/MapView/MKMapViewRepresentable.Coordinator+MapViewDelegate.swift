//
//  MKMapViewRepresentable.Coordinator+MKMapViewDelegate.swift
//  
//
//  Created by Pierre Gabory on 10/04/2023.
//

import MapKit

extension MKMapViewRepresentable.Coordinator: MKMapViewDelegate {
    
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        representable.region = mapView.region
    }

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = makeRenderer(for: overlay)
        switch renderer {
        case let polylineRenderer as MKOverlayPathRenderer:
            polylineRenderer.lineWidth = 1
            if overlay.title == "Connections" {
                polylineRenderer.lineDashPattern = [3, 10]
                polylineRenderer.strokeColor = .yellow
            } else {
                polylineRenderer.strokeColor = .orange
            }
        default:
            // Do Nothing
            break
        }
        return renderer
    }
    
    private func makeRenderer(for overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let multiPolyline as MKMultiPolyline:
            return MKMultiPolylineRenderer(multiPolyline: multiPolyline)
        case let polyline as MKPolyline:
            return MKPolylineRenderer(polyline: polyline)
        default:
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
