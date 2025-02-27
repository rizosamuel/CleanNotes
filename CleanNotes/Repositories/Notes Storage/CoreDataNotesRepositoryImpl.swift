//
//  CoreDataNotesRepositoryImpl.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import CoreData

class CoreDataNotesRepositoryImpl: NotesRepository {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
    }
    
    func add(note: Note) {
        let noteEntity = NoteEntity(context: coreDataStack.context)
        noteEntity.id = note.id
        noteEntity.title = note.title
        noteEntity.content = note.content
        noteEntity.timeStamp = note.timeStamp
        coreDataStack.save()
    }
    
    func fetchNotes(completion: @escaping ([Note]) -> Void) {
        var notes: [Note] = []
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        do {
            let noteEntities = try coreDataStack.context.fetch(fetchRequest)
            notes = noteEntities.compactMap {
                if let id = $0.id, let title = $0.title, let content = $0.content, let timeStamp = $0.timeStamp {
                    return Note(id: id, title: title, content: content, timeStamp: timeStamp)
                } else {
                    return nil
                }
            }
        } catch {
            print("Trouble fetching notes from Core Data \(error.localizedDescription)")
            notes = []
        }
        
        completion(notes)
    }
    
    func deleteAllNotes() {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        do {
            let notes = try coreDataStack.context.fetch(fetchRequest)
            
            for note in notes {
                coreDataStack.context.delete(note)
            }
    
            try coreDataStack.context.save()
        } catch {
            print("Failed to delete notes: \(error.localizedDescription)")
        }
    }
    
}
