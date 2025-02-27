//
//  Note.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

import Foundation

struct Note: Codable {
    let id: UUID
    let title: String
    let content: String
    let timeStamp: Date
}
