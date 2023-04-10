//
//  ProcessingView.swift
//  Yarn
//
//  Created by Pierre Gabory on 09/04/2023.
//

import SwiftUI
import LocationDataProcessor

struct ProcessingView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State var isRunning = false
    
    var body: some View {
        if isRunning {
            ProgressView().progressViewStyle(.circular)
        } else {
            Button("Launch Process") { start() }
        }
    }
    
    private func start() {
        Task {
            isRunning = true
            do {
                try await LocationDataProcessor(context: managedObjectContext).execute()
            } catch {
                print(error)
            }
            isRunning = false
        }
    }
}

struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView()
    }
}
