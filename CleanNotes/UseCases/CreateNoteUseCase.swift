//
//  CreateNoteUseCase.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

import Foundation

protocol CreateNoteUseCase {
    func createNote(title: String, content: String) -> Note
}

final class CreateNoteUseCaseImpl: CreateNoteUseCase {
    private let repository: NotesRepository
    
    init(repository: NotesRepository) {
        self.repository = repository
    }
    
    func createNote(title: String, content: String) -> Note {
        let newNote = Note(id: UUID(), title: title, content: content, timeStamp: Date())
        repository.add(note: newNote)
        return newNote
    }
}
