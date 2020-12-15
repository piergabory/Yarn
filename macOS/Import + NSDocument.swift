//
//  Import + NSDocument.swift
//  Yarn
//
//  Created by Pierre Gabory on 15/12/2020.
//

import AppKit
import UniformTypeIdentifiers

extension Import {
    static func filePresenter(for filePath: URL) -> NSFilePresenter? {
        try? ImportedDocument(contentsOf: filePath, ofType: UTType.json.identifier) as NSFilePresenter
    }
}

private class ImportedDocument: NSDocument {
    override func read(from data: Data, ofType typeName: String) throws { }
    override func read(from url: URL, ofType typeName: String) throws { }
}
