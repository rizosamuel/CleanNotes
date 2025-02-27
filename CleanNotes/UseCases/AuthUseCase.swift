//
//  AuthUseCase.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

typealias AuthUseCase = LoginUseCase & SignUpUseCase

final class AuthUseCaseImpl: AuthUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func executeSignup(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authRepository.signUp(email: email, password: email, completion: completion)
    }
    
    func executeLogin(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authRepository.login(email: email, password: email, completion: completion)
    }
}
