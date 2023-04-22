//
//  RootView.swift
//  Yarn
//
//  Created by Pierre Gabory on 21/04/2023.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        GeographicDataView()
            .sheet(isPresented: .constant(true)) {
                DataManagementView()
                    .scrollContentBackground(.hidden)
                    .presentationBackground(.thickMaterial)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large, .medium, .height(32)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled(true)
            }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
//            .preferredColorScheme(.dark)
    }
}
