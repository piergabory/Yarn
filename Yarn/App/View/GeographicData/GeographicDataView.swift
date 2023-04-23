//
//  GeographicDataView.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI
import MapKit

struct GeographicDataView: View {
    @Binding var hideControls: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                Map(mapRect: .constant(.world))
                    .edgesIgnoringSafeArea(.all)
                if hideControls {
                    Button { hideControls = false } label: {
                        Label("Controls", systemImage: "calendar")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .padding(.bottom, 40)
                } else {
                    GeographicDataViewControls {
                        hideControls = true
                    }
                }
            }
            MapOptionsSelectionMenu()
        }
    }
}

struct GeographicDataViewControls: View {
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: onDismiss) {
                Label("Exit", systemImage: "xmark")
                    .labelStyle(.iconOnly)
            }
            .padding(.bottom)
            DateIntevalSelector(
                dateInterval: .constant(DateInterval(start: .now, duration: 1000))
            )
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(.regularMaterial))
        .padding()
    }
}

struct DateIntevalSelector: View {
    @Binding var dateInterval: DateInterval
    
    var body: some View {
        VStack {
            DatePicker("From", selection: $dateInterval.start)
            DatePicker("to", selection: $dateInterval.end)
        }
    }
}

struct MapOptionsSelectionMenu: View {
    enum GeographicDataMapMode: CaseIterable, Identifiable {
        case pathExplorer, regionExplorer
        var id: Self { self }
    }
    
    @State var mapMode: GeographicDataMapMode = .pathExplorer
    
    var body: some View {
        Picker("", selection: $mapMode) {
            Label("Routes", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
                .tag(GeographicDataMapMode.pathExplorer)
            Label("Regions", systemImage: "mappin")
                .tag(GeographicDataMapMode.regionExplorer)
        }
        .labelStyle(.iconOnly)
        .pickerStyle(.menu)
        .background(RoundedRectangle(cornerRadius: 8).fill(.regularMaterial))
        .padding()
    }
}

struct GeographicDataView_Previews: PreviewProvider {
    static var previews: some View {
        GeographicDataView(hideControls: .constant(false))
    }
}
