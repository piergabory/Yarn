//
//  SourceImport + UIDocument.swift
//  Yarn
//
//  Created by Pierre Gabory on 04/12/2020.
//

import Foundation
import UniformTypeIdentifiers
import UIKit

extension SourceImport {
    
    var filePresenter: NSFilePresenter? {
        UIDocument(fileURL: filePath)
    }
}
