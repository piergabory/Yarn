//
//  LabsView.swift
//  Yarn
//
//  Created by Pierre Gabory on 20/05/2023.
//

import SwiftUI

struct LabsView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        List {
            Text("Hello labs.")
        }
        .toolbar {
            Button(action: onDismiss) {
                Label("Exit", systemImage: "cross")
            }
        }
    }
}

struct LabsView_Previews: PreviewProvider {
    static var previews: some View {
        LabsView { }
    }
}
