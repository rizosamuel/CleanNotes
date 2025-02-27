//
//  FileIdentifier.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/01/25.
//

protocol FileIdentifier {
    var fileName: String { get }
}

extension FileIdentifier {
    var fileName: String {
        String(describing: type(of: self))
    }
}
