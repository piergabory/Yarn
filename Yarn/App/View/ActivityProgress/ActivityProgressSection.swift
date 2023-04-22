//
//  ActivityProgressSection.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI

struct ActivityProgressSection: View {
    var body: some View {
        Section {
            ActivityProgressView(
                title: "Importing locationData.json",
                subtitle: "Decoding file",
                progress: Progress(totalUnitCount: 100)
            )
        } header: {
            Label(
                "In progress, please keep the app open.",
                systemImage: "exclamationmark.triangle.fill"
            )
        }
    }
}

struct ActivityProgressView: View {
    let title: String
    let subtitle: String
    let progress: Progress?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let progress {
                ProgressView(progress)
                    .progressViewStyle(.linear)
            }
        }
    }
}

struct ActivityProgressSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ActivityProgressSection()
        }
    }
}
