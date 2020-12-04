//
//  SourceImportList.swift
//  Yarn
//
//  Created by Pierre Gabory on 03/12/2020.
//

import SwiftUI

struct SourceImportList: View {
    @Binding private var imports: [SourceImport]
    
    init(_ imports: Binding<[SourceImport]>) {
        _imports = imports
    }
    
    var body: some View {
        if !imports.isEmpty {
            Section(header: Text("Imports")) {
                ForEach(imports) { runningImport in
                    VStack(alignment: .trailing) {
                        SourceImportView(runningImport)
                        Button("cancel") { imports.removeAll { runningImport.id == $0.id } }
                            .foregroundColor(.red)
                    }
                }
                .onDelete { imports.remove(atOffsets: $0) }
            }
        }
    }
}

private struct SourceImportView: View {
    @ObservedObject var sourceImport: SourceImport
    
    init(_ sourceImport: SourceImport) {
        self.sourceImport = sourceImport
    }
    
    var body: some View {
        ProgressView(value: sourceImport.progress) {
            Text(sourceImport.fileName)
                .font(.headline)
            Text(progressCallout)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
            .progressViewStyle(LinearProgressViewStyle())
    }
    
    var progressCallout: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.maximumIntegerDigits = 3
        let fraction = NSNumber(value: sourceImport.progress * 100.0)
        let percentage = formatter.string(from: fraction) ?? ".."
        let megabyte = 1000000
        return [
            "\(sourceImport.completedBytes / megabyte)",
            "out of",
            "\(sourceImport.totalBytes / megabyte)",
            "MB (" + percentage + "%)"
        ].joined(separator: " ")
    }
}

struct SourceImportList_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SourceImportList(.constant([.preview]))
        }
    }
}
