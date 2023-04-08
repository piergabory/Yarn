import MapKit
import SwiftUI

public struct MapView: UIViewRepresentable {
    
    private let preferredConfiguration: MKMapConfiguration
    private let selectableMapFeatures: MKMapFeatureOptions

    public init(
        preferredConfiguration: MKMapConfiguration = MKStandardMapConfiguration(),
        selectableMapFeatures: MKMapFeatureOptions = []
    ) {
        self.preferredConfiguration = preferredConfiguration
        self.selectableMapFeatures = selectableMapFeatures
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.preferredConfiguration = preferredConfiguration
        mkMapView.selectableMapFeatures = selectableMapFeatures
        return mkMapView
    }

    public func updateUIView(_ mkMapView: MKMapView, context: Context) {
        
    }
}
