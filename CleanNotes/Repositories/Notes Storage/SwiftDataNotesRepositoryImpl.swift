//
//  SwiftDataNotesRepositoryImpl.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import SwiftData

@available(iOS 17, *)
class SwiftDataNotesRepositoryImpl: @preconcurrency NotesRepository {
    private let container: ModelContainer
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    @MainActor func add(note: Note) {
        let noteModel = SwiftDataNote(id: note.id, title: note.title, content: note.content, timeStamp: note.timeStamp)
        container.mainContext.insert(noteModel)
        
        do {
            try container.mainContext.save()
        } catch {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }
    
    @MainActor func fetchNotes(completion: @escaping ([Note]) -> Void) {
        var notes: [Note] = []
        let fetchDescriptor = FetchDescriptor<SwiftDataNote>()
        
        do {
            let noteModels = try container.mainContext.fetch(fetchDescriptor)
            notes = noteModels.map {
                Note(id: $0.id, title: $0.title, content: $0.content, timeStamp: $0.timeStamp)
            }
        } catch {
            print("Failed to fetch notes: \(error.localizedDescription)")
        }
        completion(notes)
    }
    
    @MainActor func removeAllNotes() {
        let fetchDescriptor = FetchDescriptor<SwiftDataNote>()
        
        do {
            let noteModels = try container.mainContext.fetch(fetchDescriptor)
            for noteModel in noteModels {
                container.mainContext.delete(noteModel)
            }
            try container.mainContext.save()
        } catch {
            print("Failed to remove all notes: \(error.localizedDescription)")
        }
    }
}
