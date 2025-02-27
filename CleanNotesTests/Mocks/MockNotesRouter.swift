//
//  MockNotesRouter.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 24/01/25.
//

import UIKit
@testable import CleanNotes

class MockNotesRouter: NotesRouter {
    
    var didCreateNotesListVC = false
    var didNavigateToCreateNoteVC = false
    var didPresentAuthVC = false
    var didNavigateToSettingsVC = false
    var capturedNote: Note?
    var didDismiss = false
    var didNavigateToRoot = false
    
    func createNotesListVC(authRepo: AuthRepository, notesRepo: NotesRepository) -> UIViewController? {
        didCreateNotesListVC = true
        return nil
    }
    
    func presentAuthVC(authRepo: AuthRepository, useCase: AuthUseCase, delegate: AuthViewControllerDelegate) {
        didPresentAuthVC = true
    }
    
    func navigateToCreateNoteVC(useCase: CreateNoteUseCase, delegate: CreateNoteViewControllerDelegate) {
        didNavigateToCreateNoteVC = true
    }
    
    func navigateToSettingsVC(useCase: any CleanNotes.SettingsUseCase) {
        didNavigateToSettingsVC = true
    }
    
    func navigateToNoteVC(with note: Note) {
        capturedNote = note
    }
    
    func dismiss(_ viewController: UIViewController) {
        didDismiss = true
    }
    
    func navigateToRoot() {
        didNavigateToRoot = true
    }
}
