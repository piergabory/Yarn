//
//  Import + UIDocument.swift
//  Yarn
//
//  Created by Pierre Gabory on 15/12/2020.
//

import UIKit

extension Import {
    static func filePresenter(for filePath: URL) -> NSFilePresenter? {
        UIDocument(fileURL: filePath)
    }
}
