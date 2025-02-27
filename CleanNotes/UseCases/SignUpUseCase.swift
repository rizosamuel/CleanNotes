//
//  SignUpUseCase.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

protocol SignUpUseCase {
    func executeSignup(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
}

final class SignUpUseCaseImpl: SignUpUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func executeSignup(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authRepository.signUp(email: email, password: email, completion: completion)
    }
}


