//
//  CreateNoteViewModel.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

struct CreateNoteViewModel {
    
    private let useCase: CreateNoteUseCase
    
    init(useCase: CreateNoteUseCase) {
        self.useCase = useCase
    }
    
    func createNote(with title: String, content: String) -> Note {
        return useCase.createNote(title: title, content: content)
    }
}
