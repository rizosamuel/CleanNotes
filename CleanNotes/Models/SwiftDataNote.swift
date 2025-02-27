//
//  SwiftDataNoteModel.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class SwiftDataNote: Hashable {
    @Attribute(.unique) var id: UUID
    var title: String
    var content: String
    var timeStamp: Date

    init(id: UUID = UUID(), title: String, content: String, timeStamp: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.timeStamp = timeStamp
    }
}
