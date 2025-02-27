//
//  RealmNote.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

import RealmSwift

class RealmNote: Object {
    @Persisted(primaryKey: true) var id: String // UUID stored as a string
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var timeStamp: Date
    
    // Convenience initializer to create a RealmNote from a Note
    convenience init(note: Note) {
        self.init()
        self.id = note.id.uuidString
        self.title = note.title
        self.content = note.content
        self.timeStamp = note.timeStamp
    }
}
