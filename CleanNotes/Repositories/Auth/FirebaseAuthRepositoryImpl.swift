//
//  FirebaseAuthRepositoryImpl.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

import FirebaseAuth

final class FirebaseAuthRepositoryImpl: AuthRepository {
    
    private let firebaseAuth: FirebaseAuthProtocol
    private var loggedIn: Bool = false
    
    init(firebaseAuth: FirebaseAuthProtocol = Auth.auth()) {
        self.firebaseAuth = firebaseAuth
        self.loggedIn = firebaseAuth.loggedInUser != nil
    }
    
    var isLoggedIn: Bool {
        return loggedIn
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuth.signup(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Sign-Up Error: \(error.localizedDescription)")
                self?.loggedIn = false
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.currentUser else {
                print("Failed to get user after sign-up.")
                self?.loggedIn = false
                let error = NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current user is nil"])
                completion(.failure(error))
                return
            }
            
            print("User signed up successfully: \(firebaseUser.email ?? "No Email")")
            self?.loggedIn = true
            let user = User(id: firebaseUser.uid, email: firebaseUser.email)
            completion(.success(user))
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuth.login(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                self?.loggedIn = false
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.currentUser else {
                print("Failed to get user after login.")
                self?.loggedIn = false
                let error = NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current user is nil"])
                completion(.failure(error))
                return
            }
            
            print("User logged in successfully: \(firebaseUser.email ?? "No Email")")
            self?.loggedIn = true
            let user = User(id: firebaseUser.uid, email: firebaseUser.email)
            completion(.success(user))
        }
    }
    
    func logout() {
        do {
            try firebaseAuth.signOut()
            loggedIn = firebaseAuth.loggedInUser != nil
            print("User signed out successfully.")
        } catch let error {
            print("Sign-out error: \(error.localizedDescription)")
        }
    }
    
    func getCurrentUser() -> User? {
        guard let currentUser = firebaseAuth.loggedInUser else { return nil }
        return User(id: currentUser.uid, email: currentUser.email)
    }
}
