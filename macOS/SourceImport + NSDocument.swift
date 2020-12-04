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
        try? NSDocument(contentsOf: filePath, ofType: UTType.json.identifier)
    }
}
