//
//  RootView.swift
//  Yarn
//
//  Created by Pierre Gabory on 21/04/2023.
//

import SwiftUI

struct RootView: View {
    @State var isDataManagementViewVisible = true
    @State var canDismissDataManagementView = false
    
    var body: some View {
        GeographicDataView(hideControls: $isDataManagementViewVisible)
            .sheet(isPresented: $isDataManagementViewVisible) {
                DataManagementView()
                    .scrollContentBackground(.hidden)
                    .presentationBackground(.thickMaterial)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large, .medium, .height(48)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled(!canDismissDataManagementView)
            }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
//            .preferredColorScheme(.dark)
    }
}
