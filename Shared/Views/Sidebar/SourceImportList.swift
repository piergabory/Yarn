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
                        SourceImportView(runningImport) {
                            imports.removeAll { runningImport.id == $0.id }
                        }
                    }
                }
                .onDelete(perform: delete(at:))
            }
        }
    }
    
    private func delete(at indices: IndexSet) {
        for index in indices {
            imports.remove(at: index).cancel()
        }
    }
}

private struct SourceImportView: View {
    @ObservedObject var sourceImport: SourceImport
    let cancel: () -> Void
    
    init(_ sourceImport: SourceImport, cancel: @escaping () -> Void) {
        self.sourceImport = sourceImport
        self.cancel = cancel
    }
    
    var body: some View {
        VStack {
            ProgressView(value: sourceImport.progress) {
                Text(sourceImport.fileName)
            }
                .progressViewStyle(LinearProgressViewStyle())
                .font(.headline)
            HStack {
                Text(percentage)
                Text("-")
                Text("Found \(sourceImport.foundLocations) locations")
                Spacer()
                Button("cancel", action: cancel).foregroundColor(.red)
            }
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var percentage: String {
        NSString(format: #"%3.1f%%"#, sourceImport.progress * 100) as String
    }
}

struct SourceImportList_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SourceImportList(.constant([.preview]))
        }
    }
}
