//
//  SettingsView.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("Rebuild Data") {
                DescribedAction(
                    title: "Recalculate visited places",
                    description:  "toto",
                    role: nil
                ) {}
                DescribedAction(
                    title: "Reprocess all location data",
                    description:  "toto",
                    role: .destructive
                ) {}
    
            }
            Section {
                Button("Delete all data", role: .destructive) {}
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .listRowBackground(Color.red)
                    .listRowInsets(.none)
            } header: {
                Label(
                    "Nuclear option.",
                    systemImage: "exclamationmark.triangle.fill"
                )
                .foregroundColor(.red)
            }
        }
    }
}

struct DescribedAction: View {
    let title: String
    let description: String
    let role: ButtonRole?
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(title, role: role,  action: action)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
