//
//  NotesRepository.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

protocol NotesRepository {
    func add(note: Note)
    func fetchNotes(completion: @escaping ([Note]) -> Void)
}

class InMemoryNotesRepositoryImpl: NotesRepository {
    
    private var notes: [Note] = []
    
    func add(note: Note) {
        notes.append(note)
    }
    
    func fetchNotes(completion: @escaping ([Note]) -> Void) {
        completion(notes)
    }
}
