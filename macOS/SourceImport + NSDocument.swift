//
//  SourceImport + NSDocument.swift
//  Yarn
//
//  Created by Pierre Gabory on 04/12/2020.
//

import Foundation
import UniformTypeIdentifiers
import AppKit

extension SourceImport {
    
    var filePresenter: NSFilePresenter? {
        try? ImportedDocument(contentsOf: filePath, ofType: UTType.json.identifier)
    }
}

private class ImportedDocument: NSDocument {
    override func read(from data: Data, ofType typeName: String) throws { }
    override func read(from url: URL, ofType typeName: String) throws { }
}
