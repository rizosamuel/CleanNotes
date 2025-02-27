//
//  NotesRouter.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

import UIKit
import LocalAuthentication

protocol NotesRouter: Router {
    func createNotesListVC(authRepo: AuthRepository, notesRepo: NotesRepository) -> UIViewController?
    func navigateToCreateNoteVC(useCase: CreateNoteUseCase, delegate: CreateNoteViewControllerDelegate)
    func navigateToNoteVC(with note: Note)
    func presentAuthVC(authRepo: AuthRepository, useCase: AuthUseCase, delegate: AuthViewControllerDelegate)
    func navigateToSettingsVC(useCase: SettingsUseCase)
    func dismiss(_ viewController: UIViewController)
    func navigateToRoot()
}

class NotesRouterImpl: NotesRouter {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func createNotesListVC(authRepo: AuthRepository, notesRepo: NotesRepository) -> UIViewController? {
        let NotesListVM = NotesListViewModel(authRepo: authRepo, notesRepo: notesRepo)
        let NotesListVC = NotesListViewController(viewModel: NotesListVM, router: self)
        navigationController?.setViewControllers([NotesListVC], animated: false)
        return navigationController
    }
    
    func presentAuthVC(authRepo: AuthRepository, useCase: AuthUseCase, delegate: AuthViewControllerDelegate) {
        let loginVM = LoginViewModel(authRepo: authRepo, useCase: useCase)
        let loginVC = AuthViewController(viewModel: loginVM)
        loginVC.delegate = delegate
        let loginNavVC = UINavigationController(rootViewController: loginVC)
        navigationController?.present(loginNavVC, animated: true) {
            print("completed")
        }
    }
    
    func navigateToNoteVC(with note: Note) {
        let noteVM = NoteViewModel(note: note)
        let noteVC = NoteViewController(viewModel: noteVM, router: self)
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    func navigateToCreateNoteVC(useCase: CreateNoteUseCase, delegate: CreateNoteViewControllerDelegate) {
        let createNoteVM = CreateNoteViewModel(useCase: useCase)
        let createNoteVC = CreateNoteViewController(viewModel: createNoteVM, router: self)
        createNoteVC.delegate = delegate
        let createNoteNavVC = UINavigationController(rootViewController: createNoteVC)
        navigationController?.present(createNoteNavVC, animated: true)
    }
    
    func navigateToSettingsVC(useCase: SettingsUseCase) {
        let repository = FirebaseAuthRepositoryImpl()
        let biometricsRepo = BiometricsRepositoryImpl(context: LAContext())
        let userDefaultsRepo = UserDefaultsRepositoryImpl()
        let biometricsUseCase = BiometricsUseCaseImpl(biometricsRepo: biometricsRepo, userDefaultsRepo: userDefaultsRepo)
        let settingsVM = SettingsViewModel(useCase: useCase, authRepo: repository, biometricsUseCase: biometricsUseCase, userDefaultsRepo: userDefaultsRepo)
        let settingsVC = SettingsViewController(viewModel: settingsVM, router: self)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func dismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
    
    func navigateToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
