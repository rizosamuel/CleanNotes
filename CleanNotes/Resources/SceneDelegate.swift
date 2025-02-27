//
//  SceneDelegate.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

import UIKit
import SwiftData

class SceneDelegate: UIResponder, UIWindowSceneDelegate, FileIdentifier {
    
    var window: UIWindow?
    var router: NotesRouter?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        router = NotesRouterImpl(navigationController: navigationController)
        let authRepo = getAuthRepository()
        let notesRepo = getNotesRepository()
        let initialViewController = router?.createNotesListVC(authRepo: authRepo, notesRepo: notesRepo)
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        print("\n[\(fileName)] CREATED ROOT VIEW CONTROLLER FOR \(String(describing: window))")
    }
    
    private func getAuthRepository() -> AuthRepository {
        return FirebaseAuthRepositoryImpl()
    }
    
    private func getNotesRepository() -> NotesRepository {
        return FirebaseNotesRepositoryImpl()
    }
}
