//
//  SettingsView.swift
//  Yarn
//
//  Created by Pierre Gabory on 22/04/2023.
//

import SwiftUI
import SafariServices

struct SettingsView: View {
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                AutomaticTrackingSettingsSection()
                RebuildDataSettingsSection()
                DeleteAllDataSettingsSection()
                AboutMeSettingsSection()
            }
            .navigationBarTitle("Settings")
            .toolbar {
                Button(action: onDismiss) {
                    Label("Exit", systemImage: "xmark")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
        }
    }
}

struct AutomaticTrackingSettingsSection: View {
    var body: some View {
        Section("Automatic tracking") {
            Toggle("Automatic Tracking", isOn: .constant(false))
            Toggle("High precision tracking", isOn: .constant(false))
            Toggle("Import Photos location data", isOn: .constant(false))
            Button("Open to system settings") { }
        }
    }
}

struct RebuildDataSettingsSection: View {
    var body: some View {
        Section("Rebuild Data") {
            Button("Recalculate visited places") { }
            Button("Reprocess all location data") { }
        }
    }
}

struct DeleteAllDataSettingsSection: View {
    private let disclosure = """
        This will definitively remove all data. You cannot undo this.

        You can trust me, i dont store any data
        """
    
    var body: some View {
        Section {
            Button("Delete all data", role: .destructive) {}
        } header: {
            Text("Nuclear option.")
        } footer: {
            Text(disclosure)
        }
    }
}

struct AboutMeSettingsSection: View {
    var body: some View {
        Section {
            Link(destination: URL(string: "mailto:contact@piergabory.com")!) {
                Label("Send feedback", systemImage: "envelope")
            }
            Link(destination: URL(string: "https://piergabory.com")!) {
                Label("About me", systemImage: "safari")
            }
        }
        .foregroundColor(.primary)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView { }
    }
}
