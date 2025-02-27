//
//  NotesListViewModel.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

import Foundation
import FirebaseAuth

class NotesListViewModel {
    
    let authRepository: AuthRepository
    let notesRepository: NotesRepository
    
    var notes: [Note] = []
    
    init(authRepo: AuthRepository, notesRepo: NotesRepository) {
        self.authRepository = authRepo
        self.notesRepository = notesRepo
    }
    
    func fetchNotes(completion: @escaping () -> Void) {
        notesRepository.fetchNotes { [weak self] notes in
            self?.notes = notes
            completion()
        }
    }
}
