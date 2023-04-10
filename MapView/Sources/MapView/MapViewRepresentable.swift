import MapKit
import SwiftUI

public protocol MapViewRepresentable {
    associatedtype Coordinator
    func makeMKMapView(context: MapViewRepresentableContext<Self>) -> MKMapView
    func updateMKMapView(_ mkMapView: MKMapView, context: MapViewRepresentableContext<Self>)
}

@MainActor
public struct MapViewRepresentableContext<MapView: MapViewRepresentable> {
    let coordinator: MapView.Coordinator
    let transaction: Transaction
    let environment: EnvironmentValues
}

#if __IOS__
extension MapViewRepresentable: UIViewRepresentable {
    public func makeUIView(context: Context) -> MKMapView {
        makeMKMapView(context: mapContext(from: context))
    }
    
    public func updateUIView(_ mkMapView: MKMapView, context: Context) {
        updateMKMapView(mkMapView, context: mapContext(from: context))
    }
    
    private func mapContext(from context: Context) -> MapViewRepresentableContext<Self> {
        let mapContext = MapContext(
            coordinator: context.coordinator,
            transaction: context.transaction,
            environment: context.environment
        )
    }
}
#endif

#if __MAC_OS__
extension MapViewRepresentable: NSViewRepresentable {
    public func makeNSView(context: Context) -> MKMapView {
        makeMKMapView(context: mapContext(from: context))
    }
    
    public func updateNSView(_ mkMapView: MKMapView, context: Context) {
        updateMKMapView(mkMapView, context: mapContext(from: context))
    }
    
    private func mapContext(from context: Context) -> MapViewRepresentableContext<Self> {
        let mapContext = MapContext(
            coordinator: context.coordinator,
            transaction: context.transaction,
            environment: context.environment
        )
    }
}
#endif
