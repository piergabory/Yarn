import MapKit
import SwiftUI

public struct MapView: UIViewRepresentable {
    
    public init() {

    }
    
    public func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    public func updateUIView(_ mkMapView: MKMapView, context: Context) {
        
    }
}
