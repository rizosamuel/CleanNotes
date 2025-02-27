//
//  AuthRepository.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

import FirebaseAuth

protocol AuthRepository {
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func logout()
    func getCurrentUser() -> CleanNotes.User?
    var isLoggedIn: Bool { get }
}
