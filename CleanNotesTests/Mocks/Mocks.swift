//
//  Mocks.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import UIKit
@testable import CleanNotes

class MockNavigationController: UINavigationController {
    var pushedVC: UIViewController?
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

class MockNotesRepository: NotesRepository {
    var addedNote: Bool = false
    var fetchedNotes: Bool = false
    var notes: [Note] = []
    
    func add(note: Note) {
        addedNote = true
        notes.append(note)
    }
    
    func fetchNotes(completion: @escaping ([Note]) -> Void) {
        fetchedNotes = true
        completion(notes)
    }
}

class MockCreateNoteUseCase: CreateNoteUseCase {
    var capturedTitle: String?
    var capturedContent: String?
    var createdNote = false
    
    func createNote(title: String, content: String) -> Note {
        capturedTitle = title
        capturedContent = content
        defer { createdNote = true }
        return Note(id: UUID(), title: title, content: content, timeStamp: Date())
    }
}

class MockCreateNoteViewControllerDelegate: CreateNoteViewControllerDelegate {
    var createdNote = false
    
    func didCreateNote(with note: Note) {
        createdNote = true
    }
}

class MockAuthViewControllerDelegate: AuthViewControllerDelegate {
    var loggedIn = false
    
    func didLogin() {
        loggedIn = true
    }
}

class MockViewController: UIViewController {
    var dismissCalled = false
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
        super.dismiss(animated: flag, completion: completion)
    }
}

class MockNotesListViewModel: NotesListViewModel {
    var mockNotes: [Note] = []
    var didFetchNotes = false
    
    override var notes: [Note] {
        get {
            return mockNotes
        }
        set {
            mockNotes = newValue
        }
    }
    
    override func fetchNotes(completion: @escaping () -> Void) {
        didFetchNotes = true
    }
}

class MockAuthUseCase: AuthUseCase {
    var shouldSucceed: Bool = true
    var mockUser = CleanNotes.User(id: "mockId", email: "mockEmail@gmail.com")
    var mockError = NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])
    
    func executeSignup(email: String, password: String, completion: @escaping (Result<CleanNotes.User, Error>) -> Void) {
        if shouldSucceed {
            mockUser.email = email
            completion(.success(mockUser))
        } else {
            completion(.failure(mockError))
        }
    }
    
    func executeLogin(email: String, password: String, completion: @escaping (Result<CleanNotes.User, Error>) -> Void) {
        if shouldSucceed {
            mockUser.email = email
            completion(.success(mockUser))
        } else {
            completion(.failure(mockError))
        }
    }
}

class MockSettingsRepository: SettingsRepository {
    
    var fetchedSettings: Bool = false
    var settingSections: [SettingSection] = [
        SettingSection(title: "mock section", settings: [Setting(title: "mock setting", type: .appLock)])
    ]
    
    func fetchSettings(completion: @escaping ([SettingSection]) -> Void) {
        fetchedSettings = true
        completion(settingSections)
    }
}

class MockSettingsUseCase: SettingsUseCase {
    
    var shouldSucceed: Bool = true
    var settingSections: [SettingSection] = [
        SettingSection(title: "mock section", settings: [Setting(title: "mock setting", type: .appLock)])
    ]
    
    func execute(completion: @escaping ([SettingSection]) -> Void) {
        if shouldSucceed {
            completion(settingSections)
        } else {
            completion([])
        }
    }
}

class MockSettingsViewModel: SettingsViewModel {
    
    var didFetchSettings = false
    var mockSections: [SettingSection] = []
    
    override var sections: [SettingSection] {
        get {
            return mockSections
        }
        set {
            mockSections = newValue
        }
    }
    
    override func fetchSettings(completion: @escaping () -> Void) {
        didFetchSettings = true
        completion()
    }
}

class MockUserDefaultsRepository: UserDefaultsRepository {
    
    private var userDefaultsDict: [String: Data] = [:]

    func save<T: Codable>(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaultsDict[key] = data
        } catch {
            print("Failed to encode value for key \(key): \(error)")
        }
    }

    func get<T: Codable>(forKey key: String, type: T.Type) -> T? {
        guard let data = userDefaultsDict[key] else {
            return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Failed to decode value for key \(key): \(error)")
            return nil
        }
    }

    func delete(forKey key: String) {
        userDefaultsDict.removeValue(forKey: key)
    }
    
    func clearAll(userDefaultsName: String? = nil) {
        userDefaultsDict = [:]
    }
}

class MockBiometricsRepository: BiometricsRepository {
    var isBiometricsAvailable: Bool = false
    var biometryErrorReason: String = ""
    var shouldAuthenticateSucceed: Bool = false
    var authenticateCalled = false

    func authenticate(completion: @escaping (Bool, String) -> Void) {
        authenticateCalled = true
        completion(shouldAuthenticateSucceed, shouldAuthenticateSucceed ? "" : "Authentication failed")
    }
}

class MockBiometricsUseCase: BiometricsUseCase {
    
    var isBiometricsAvailable: Bool = true
    
    var biometryErrorReason: String = ""
    
    var isAuthenticated: Bool = false
    
    func authenticate(completion: @escaping (Bool, String) -> Void) {
        completion(isAuthenticated, biometryErrorReason)
    }
}
