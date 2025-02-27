//
//  MockAuthRepository.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/02/25.
//

import Foundation
@testable import CleanNotes

class MockAuthRepository: AuthRepository {
    
    enum ResultType { case success, failure }
    
    var isLoggedIn: Bool = false
    var didSignUp: Bool = false
    var didLogin: Bool = false
    var didLogout: Bool = false
    var currentUser: CleanNotes.User?
    
    private var isSuccess: Bool = false
    
    let mockError = NSError(domain: "MockAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock login/signup error"])
    
    func setupFor(_ resultType: ResultType) {
        switch resultType {
        case .success:
            isSuccess = true
        case .failure:
            isSuccess = false
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<CleanNotes.User, Error>) -> Void) {
        didSignUp = isSuccess
        if isSuccess {
            let user = CleanNotes.User(id: "mockId", email: email)
            completion(.success(user))
        } else {
            completion(.failure(mockError))
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<CleanNotes.User, Error>) -> Void) {
        didLogin = isSuccess
        if isSuccess {
            let user = CleanNotes.User(id: "mockId", email: email)
            completion(.success(user))
        } else {
            completion(.failure(mockError))
        }
    }
    
    func logout() {
        didLogout = true
    }
    
    func getCurrentUser() -> CleanNotes.User? {
        return nil
    }
}
