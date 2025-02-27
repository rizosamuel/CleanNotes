//
//  LoginUseCase.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

protocol LoginUseCase {
    func executeLogin(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
}

final class LoginUseCaseImpl: LoginUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func executeLogin(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authRepository.login(email: email, password: email, completion: completion)
    }
}
