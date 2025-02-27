//
//  SQLiteNotesRepositoryImpl.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import Foundation
import SQLite

class SQLiteNotesRepositoryImpl: NotesRepository {
    
    typealias SQLExpression = SQLite.Expression
    
    private let databaseUrl: URL
    private let db: Connection
    private let notesTable: Table
    private let id: SQLExpression<String>  // Storing UUID as String
    private let title: SQLExpression<String>
    private let content: SQLExpression<String>
    private let timeStamp: SQLExpression<Date>
    
    init(
        databaseName: String = "notes.sqlite3",
        fileManager: FileManager = FileManager.default
    ) throws {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        self.databaseUrl = documentDirectory!.appendingPathComponent(databaseName)
        
        // Set up the SQLite database connection
        db = try Connection(databaseUrl.path)
        notesTable = Table("notes")
        id = SQLExpression<String>("id")  // UUID as String
        title = SQLExpression<String>("title")
        content = SQLExpression<String>("content")
        timeStamp = SQLExpression<Date>("timeStamp")
        
        // Create the table if it doesn't exist
        try createTableIfNeeded()
    }
    
    private func createTableIfNeeded() throws {
        // Create the notes table with columns id, title, content, and timeStamp
        try db.run(notesTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(title)
            t.column(content)
            t.column(timeStamp)
        })
    }
    
    func add(note: Note) {
        // Insert a new note into the database
        let insert = notesTable.insert(
            id <- note.id.uuidString,  // Convert UUID to String
            title <- note.title,
            content <- note.content,
            timeStamp <- note.timeStamp
        )
        do {
            try db.run(insert)
            print("Note added successfully!")
        } catch {
            print("Error adding note: \(error)")
        }
    }
    
    func fetchNotes(completion: @escaping ([Note]) -> Void) {
        // Fetch all notes from the database
        var notes: [Note] = []
        do {
            for note in try db.prepare(notesTable) {
                let noteId = UUID(uuidString: note[id]) ?? UUID()
                let noteTitle = note[title]
                let noteContent = note[content]
                let noteTimeStamp = note[timeStamp]
                notes.append(Note(id: noteId, title: noteTitle, content: noteContent, timeStamp: noteTimeStamp))
            }
        } catch {
            print("Error fetching notes: \(error)")
        }
        completion(notes)
    }
    
    func deleteAllNotes() {
        // Delete all notes from the database
        do {
            try db.run(notesTable.delete())
            print("All notes deleted successfully!")
        } catch {
            print("Error deleting notes: \(error)")
        }
    }
}
